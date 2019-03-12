require 'phantomjs'
require 'capybara'
require 'capybara/dsl'
require 'capybara/cucumber'
require 'capybara/poltergeist'

Capybara.app_host = 'http://tax-tribunals-datacapture-staging.dsd.io/'
Capybara.run_server = false
Capybara.default_driver = ENV['DRIVER']&.to_sym || :poltergeist
Capybara.javascript_driver = :poltergeist

options = {
  js_errors: false,
  phantomjs: Phantomjs.path
}

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, options)
end

Capybara.configure do |config|
  driver = ENV['DRIVER']&.to_sym || :poltergeist
  config.default_driver = driver
  config.default_max_wait_time = 30
  config.match = :prefer_exact
  config.visible_text_only = true
end

Capybara.register_driver :firefox do |app|
  options = Selenium::WebDriver::Firefox::Options.new
  Capybara::Selenium::Driver.new(app, browser: :firefox, marionette: true, options: options)
end

Capybara::Screenshot.register_filename_prefix_formatter(:cucumber) do |scenario|
  title = scenario.name.tr(' ', '-').gsub(%r{/^.*\/cucumber\//}, '')
  "screenshot_cucumber_#{title}"
end
