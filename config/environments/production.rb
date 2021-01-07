Rails.application.configure do
  # config.logger = ActiveSupport::Logger.new("log/#{Rails.env}.log")
  # config.lograge.logger = ActiveSupport::Logger.new(STDOUT)
  # config.lograge.enabled = true
  # config.lograge.formatter = Lograge::Formatters::Logstash.new
  config.log_level = :debug
  # config.action_view.logger = nil

  # config.lograge.custom_options = lambda do |event|
  #   exceptions = %w(controller action format id)
  #   {
  #     host: event.payload[:host],
  #     params: event.payload[:params].except(*exceptions),
  #     referrer: event.payload[:referrer],
  #     session_id: event.payload[:session_id],
  #     tags: %w{taxtribs-datacapture},
  #     user_agent: event.payload[:user_agent]
  #   }
  # end

  config.cache_classes = true
  config.cache_store = :memory_store

  config.eager_load = true

  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = false
  config.sass.style = :compressed
  config.sass.line_comments = false

  config.assets.compile = false

  config.log_tags = [ :request_id ]
  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = true
  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  config.active_record.dump_schema_after_migration = false

  # NB: Because of the way the form builder works, and hence the
  # gov.uk elements formbuilder, exceptions will not be raised for
  # missing translations of model attribute names. The form will
  # get the constantized attribute name itself, in form labels.
  config.action_view.raise_on_missing_translations = false

  config.force_ssl = true
  config.ssl_options = {
    hsts: { expires: 1.year, preload: true },
    redirect: { exclude: ->(request) { /status\.json/.match?(request.path) } }
  }

  Raven.configure do |config|
    config.ssl_verification = ENV['SENTRY_SSL_VERIFICATION'] == true
  end

  config.active_record.dump_schema_after_migration = false
end
