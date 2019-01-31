require 'phantomjs'
require 'capybara'
require 'capybara/dsl'
require 'capybara/cucumber'
require 'capybara/poltergeist'

Capybara.app_host = ENV.fetch('DATACAPTURE_URI')
Capybara.run_server = false
Capybara.default_driver = :poltergeist
Capybara.javascript_driver = :poltergeist

options = {
  js_errors: false,
  phantomjs: Phantomjs.path
}

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, options)
end
