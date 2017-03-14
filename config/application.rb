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

    config.session_expire_after = 30 # minutes
    config.survey_link = 'https://goo.gl/forms/5MeKnK5kGJH99Fsn2'
    config.feedback_email = 'taxtribunals_helpdesk@digital.justice.gov.uk'
    config.tax_tribunal_email = 'taxappeals@hmcts.gsi.gov.uk'
    config.tax_tribunal_phone = '0300 123 1024'

    config.x.session.expires_in_minutes = 2 #minutes
    config.x.session.warning_when_remaining = 1
  end
end
