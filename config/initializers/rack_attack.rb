class Rack::Attack

  ### Allow all from localhost ###

  # Always allow requests from localhost
  # (blocklist & throttles are skipped)
  unless ENV['DISABLE_RACK_ATTACK_SAFELIST']
    Rack::Attack.safelist('allow from localhost') do |req|
      ('127.0.0.1' == req.ip || '::1' == req.ip)
    end
  end

  ### Block email addresses from submitting the Report a problem page ###

  # This blocklist forbids users/bots from submitting the Report a Problem page
  # by comparing the form email address against the RACK_ATTACK_BLOCKLIST_EMAILS
  # env var.
  #
  # The RACK_ATTACK_BLOCKLIST needs to be a comma separated string
  # with email address or domain names followed after the @ symbol.
  # e.g. "john@example.com,@suspicious-domain.com"

  # Read RACK_ATTACK_BLOCKLIST_EMAILS and filter out non email or domain names
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

# Return custom message when throttling blocks an IP address
Rack::Attack.throttled_response = lambda do |request|
  [ 429, {}, ["We have received too many requests from your IP address. Please try again later.\n"]]
end
