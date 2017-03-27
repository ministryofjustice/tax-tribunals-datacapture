# Will use SENTRY_DSN environment variable if set
# :nocov:
Raven.configure do |config|
  config.environments = %w( production )
  config.silence_ready = true
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
end
# :nocov:
