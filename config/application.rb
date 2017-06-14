require_relative 'boot'

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

# Ensure that when running the application through Rake the RAILS_ENV doesn't incorrectly
# get replaced with 'development' when running the specs.
# Adapted from `railties/lib/rails/test_unit/railtie.rb`.
# :nocov:
if defined?(Rake.application) &&
    Rake.application.top_level_tasks.grep(/^(default$|spec(:|$))/).any?
  ENV["RAILS_ENV"] ||= "test"
end
# :nocov:

Bundler.require(*Rails.groups)

module TaxTribunalsDatacapture
  class Application < Rails::Application
    ActionView::Base.default_form_builder = GovukElementsFormBuilder::FormBuilder

    # This automatically adds id: :uuid to create_table in all future migrations
    config.active_record.primary_key = :uuid

    config.survey_link = 'https://goo.gl/forms/5MeKnK5kGJH99Fsn2'
    config.kickout_survey_link = 'https://goo.gl/forms/Ccx0sJcOs5cSVYks2'

    # This is the GDS-hosted homepage for our service, and the one with a `start` button
    config.gds_service_homepage_url = 'https://www.gov.uk/tax-tribunal'.freeze

    config.tax_tribunal_email = 'taxappeals@hmcts.gsi.gov.uk'
    config.tax_tribunal_phone = '0300 123 1024'

    config.x.session.expires_in_minutes = ENV.fetch('SESSION_EXPIRES_IN_MINUTES', 30).to_i
    config.x.session.warning_when_remaining = ENV.fetch('SESSION_WARNING_WHEN_REMAINING', 5).to_i

    config.x.cases.expire_in_days = ENV.fetch('EXPIRE_AFTER', 14).to_i
    config.x.users.expire_in_days = ENV.fetch('USERS_EXPIRE_AFTER', 30).to_i

    config.action_mailer.default_url_options = { host: ENV.fetch('EXTERNAL_URL') }
  end
end
