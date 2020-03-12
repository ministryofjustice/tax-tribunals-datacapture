class Rack::Attack

  ### Allow all from localhost ###

  # Always allow requests from localhost
  # (blocklist & throttles are skipped)
  Rack::Attack.safelist('allow from localhost') do |req|
    '127.0.0.1' == req.ip || '::1' == req.ip
  end

  ### Block email addresses from submitting the Report a problem page ###

  # This filter blocks users/bots from submitting the Report a Problem page by
  # comparing the form email address against the RACK_ATTACK_BLOCKLIST_EMAILS
  # env var.
  #
  # RACK_ATTACK_BLOCKLIST needs to be a comma separated string
  # e.g. "foo.com, bar.com"

  spammers = ENV.fetch('RACK_ATTACK_BLOCKLIST_EMAILS', '').split(/,\s*/)
  spammer_regexp = Regexp.union(spammers)

  blocklist("block emails") do |req|
    req.path =~ /feedback/i &&
    req.post? &&
    req.params['surveys_feedback_form']['email'] =~ spammer_regexp
  end

  ### Prevent DOS Attack on the Report a Problem page ###

  # Throttle POST requests to /feedback paths by IP address
  #
  # Key: "rack::attack:#{Time.now.to_i/:period}:feedback/ip:#{req.ip}"
  throttle('feedback/ip', limit: 1, period: 1.minute) do |req|
    if req.path =~ /feedback/i && req.post?
      req.ip
    end
  end
end
