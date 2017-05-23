require "logstash-logger"

module LogStashLogger
  module Formatter
    class RemoveEscapeSequences < LogStashLogger::Formatter::Base
      def call(severity, time, progname, message)
        message&.gsub!(/\e\[(\d+)m/, '')&.strip! if message.is_a?(String)
        super
        "#{@event.to_json}\n"
      end
    end
  end
end

LogStashLogger.configure do |config|
  config.customize_event do |event|
    event['tags'] << 'taxtribs-datacapture'
  end
end

Rails.application.configure do
  config.logstash.type = :stdout
  config.logstash.formatter = LogStashLogger::Formatter::RemoveEscapeSequences
  config.log_level = :info
  config.action_view.logger = nil

  config.cache_classes = true

  config.eager_load = true

  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  config.assets.js_compressor = :uglifier

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
end
