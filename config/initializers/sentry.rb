# # :nocov:
# Sentry.init do |config|
#   config.dsn = ENV['SENTRY_DSN']
#   config.breadcrumbs_logger = [:sentry_logger, :active_support_logger]
#   config.environment = 'production'
#   config.enabled_environments = ['production']

#   # To activate performance monitoring, set one of these options.
#   # We recommend adjusting the value in production:
#   config.traces_sample_rate = 0.9

#  # This line is from old sentry gem config. I checked and the data sent to sentry UI are filtered based on the
#  # Rails.application.config.filter_parameters.map(&:to_s) values
#  # config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)

#  # Old config value. I didn't find the alternative in a new gem.
#  # config.ssl_verification = ENV['SENTRY_SSL_VERIFICATION'] == true
# end
# # :nocov: