class Rack::Attack

  ### Allow all from localhost ###

  # Always allow requests from localhost
  # (blocklist & throttles are skipped)
  unless ENV['DISABLE_RACK_ATTACK_SAFELIST']
    Rack::Attack.safelist('allow from localhost') do |req|
      ('127.0.0.1' == req.ip || '::1' == req.ip)
    end
  end

end
