# :nocov:
class Rack::Attack

  ### Safelists ###

  # Blocklists & Throttles are skipped by default unless
  # the DISABLE_RACK_ATTACK_SAFELISTS is used.

  unless ENV['DISABLE_RACK_ATTACK_SAFELISTS']
    Rack::Attack.safelist('allow from localhost') do |req|
      ('127.0.0.1' == req.ip || '::1' == req.ip)
    end
  end

  ### Email blocklist for the Report a problem page ###

  # This blocklist forbids users/bots from submitting the Report a Problem page
  # by comparing the form email address against the RACK_ATTACK_BLOCKLIST_EMAILS
  # env var.
  #
  # The RACK_ATTACK_BLOCKLIST_EMAILS needs to be a comma separated string
  # with email address or domain names followed after the @ symbol.
  # e.g. "john@example.com,@suspicious-domain.com"

  # Filter out non email or domain names
  spammers = ENV.fetch('RACK_ATTACK_BLOCKLIST_EMAILS', '').split(/,\s*/).select do
    |email| email.match? /@[A-Z0-9.-]+\.[A-Z]{2,4}/i
  end
  spammer_regexp = Regexp.union(spammers)

  blocklist("block emails") do |req|
    req.path =~ /feedback/i &&
    req.post? &&
    req.params['surveys_feedback_form']['email'] =~ spammer_regexp
  end

  ### Exponential backoff for POST requests to "/feedback" paths ###

  # Allows 8 requests/IP in 15 minutes
  #        16 requests/IP in 2.5 hours
  #        32 requests/IP in 25 hours
  (3..5).each do |level|
    throttle("feedback/ip/#{level}",
               :limit => (2 ** level),
               :period => (0.9 * (10 ** level)).to_i.seconds) do |req|
      if req.path =~ /feedback/i && req.post?
        req.ip
      end
    end
  end
end

### Custom responses

# Return a custom message for throttled requests
Rack::Attack.throttled_response = lambda do |request|
  [ 429, {}, ["We have received too many requests from your IP address. Please try again later.\n"]]
end

### Custom Logs

# Log throttled requests
ActiveSupport::Notifications.subscribe('rack.attack') do |name, start, finish, request_id, req|
  if req.env["rack.attack.match_type"] == :throttle
    Rails.logger.info "[Rack::Attack][Blocked] " <<
                      "ip: #{req.ip}, " <<
                      "path: #{req.path}"
  end
end
# :nocov:
