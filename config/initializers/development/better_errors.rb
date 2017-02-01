#:nocov:
if defined? BetterErrors
  BetterErrors::Middleware.allow_ip! '10.0.0.0/8'
  BetterErrors::Middleware.allow_ip! '172.16.0.0/12'
  BetterErrors::Middleware.allow_ip! '192.168.0.0/16'
end
#:nocov:
