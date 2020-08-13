require_relative 'boot'

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module TaxTribunalsDatacapture
  class Application < Rails::Application
    config.load_defaults 6.0

    ActionView::Base.default_form_builder = GovukElementsFormBuilder::FormBuilder

    config.middleware.use Rack::Attack

    # This automatically adds id: :uuid to create_table in all future migrations
    config.active_record.primary_key = :uuid

    config.survey_link = 'https://www.smartsurvey.co.uk/s/TTExit20/'.freeze
    config.kickout_survey_link = 'https://goo.gl/forms/Ccx0sJcOs5cSVYks2'.freeze

    # This is the GDS-hosted homepage for our service, and the one with a `start` button
    config.gds_service_homepage_url = 'https://www.gov.uk/tax-tribunal'.freeze

    config.tax_tribunal_email = 'taxappeals@hmcts.gsi.gov.uk'
    config.tax_tribunal_phone = '0300 123 1024'

    config.x.session.expires_in_minutes = ENV.fetch('SESSION_EXPIRES_IN_MINUTES', 30).to_i
    config.x.session.warning_when_remaining = ENV.fetch('SESSION_WARNING_WHEN_REMAINING', 5).to_i

    config.x.cases.expire_in_days = ENV.fetch('EXPIRE_AFTER', 14).to_i
    config.x.users.expire_in_days = ENV.fetch('USERS_EXPIRE_AFTER', 30).to_i

    config.action_mailer.default_url_options = { host: ENV.fetch('EXTERNAL_URL') }

    if ENV['AZURE_APP_INSIGHTS_INSTRUMENTATION_KEY']
      config.middleware.use ApplicationInsights::Rack::TrackRequest, ENV['AZURE_APP_INSIGHTS_INSTRUMENTATION_KEY']
    end
  end
end
