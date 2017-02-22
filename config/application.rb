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
  end
end
