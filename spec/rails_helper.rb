ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require_relative '../spec/support/view_spec_helpers'
require_relative '../spec/helpers/authentication_helpers_spec'
require './spec/support/email_validation_helpers'

ActiveRecord::Migration.maintain_test_schema!

RSpec::Expectations.configuration.on_potential_false_positives = :nothing

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.include(ViewSpecHelpers, type: :helper)
  config.include(ActiveSupport::Testing::TimeHelpers)

  config.include(Devise::Test::ControllerHelpers, type: :view)
  config.include(Devise::Test::ControllerHelpers, type: :controller)
  config.include(AuthenticationHelpers, type: :controller)
  config.include EmailValidationHelpers

  config.before(:each, type: :helper) { initialize_view_helpers(helper) }
end

RSpec::Matchers.define_negated_matcher :not_change, :change
