Selenium::WebDriver.logger.level = :error

Capybara.configure do |config|
  driver = ENV['DRIVER']&.to_sym || :headless
  config.default_driver = driver
  config.default_max_wait_time = 30
  config.match = :prefer_exact
  config.exact = true
  config.visible_text_only = true
end

Capybara.register_driver :apparition do |app|
  Capybara::Apparition::Driver.new(app, js_errors: false)
end


Capybara.register_driver :headless do |app|
  chrome_options = Selenium::WebDriver::Chrome::Options.new(args: ['headless', 'disable-gpu', 'window-size=1366,768'])
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: chrome_options)
end

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara::Screenshot.register_driver(:chrome) do |driver, path|
  driver.browser.save_screenshot(path)
end

Capybara.register_driver :firefox do |app|
  options = Selenium::WebDriver::Firefox::Options.new
  Capybara::Selenium::Driver.new(app, browser: :firefox, marionette: true, options: options)
end


Capybara.register_driver :safari do |app|
  Capybara::Selenium::Driver.new(app, browser: :safari)
end

Capybara::Screenshot.register_filename_prefix_formatter(:cucumber) do |scenario|
  title = scenario.name.tr(' ', '-').gsub(%r{/^.*\/cucumber\//}, '')
  "screenshot_cucumber_#{title}"
end

#............. Sauce Labs .............#

Capybara.register_driver :chrome_saucelabs do |app|
  browser = {:browserName=>"chrome", :name=>"WIN_CHROME_LATEST", :platform=>"Windows 10", :version=>"latest"}
  Capybara::Selenium::Driver.new(app, browser: :remote, url: "http://#{ENV['SAUCE_USERNAME']}:#{ENV['SAUCE_ACCESS_KEY']}@ondemand.eu-central-1.saucelabs.com:80/wd/hub", desired_capabilities: browser)
end

Capybara.register_driver :ms_edge_saucelabs do |app|
  browser = {:browserName=>"MicrosoftEdge", :name=>"EDGE_LATEST", :platform=>"Windows 10", :version=>"latest"}
  Capybara::Selenium::Driver.new(app, browser: :remote, desired_capabilities: browser, url: "http://#{ENV['SAUCE_USERNAME']}:#{ENV['SAUCE_ACCESS_KEY']}@ondemand.eu-central-1.saucelabs.com:80/wd/hub")
end

Capybara.register_driver :ff_saucelabs do |app|
  browser = {:browserName=>"firefox", :name=>"FIREFOX_LATEST", :platform=>"Windows 10", :version=>"latest", :acceptInsecureCerts=>true}
  Capybara::Selenium::Driver.new(app, browser: :remote, desired_capabilities: browser, url: "http://#{ENV['SAUCE_USERNAME']}:#{ENV['SAUCE_ACCESS_KEY']}@ondemand.eu-central-1.saucelabs.com:80/wd/hub")
end

# Doesn't go past the home page
Capybara.register_driver :safari_saucelabs do |app|
  capabilities = {
      browser: 'safari',
      version: 'latest',
      platform: 'macOS 10.15',
      "sauce:options" => {
          screen_resolution: '2360x1770',
      }
  }
  caps = Selenium::WebDriver::Remote::Capabilities.send('safari', capabilities)
  Capybara::Selenium::Driver.new(app, browser: :remote, desired_capabilities: caps, url: "http://#{ENV['SAUCE_USERNAME']}:#{ENV['SAUCE_ACCESS_KEY']}@ondemand.eu-central-1.saucelabs.com:80/wd/hub")
end

Capybara.register_driver :ie_saucelabs do |app|
  capabilities = {
      browser: 'internet_explorer',
      version: 'latest',
      platform: 'Windows 10',
  }
  caps = Selenium::WebDriver::Remote::Capabilities.send('internet_explorer', capabilities)
  Capybara::Selenium::Driver.new(app, browser: :remote, desired_capabilities: caps, url: "http://#{ENV['SAUCE_USERNAME']}:#{ENV['SAUCE_ACCESS_KEY']}@ondemand.eu-central-1.saucelabs.com:80/wd/hub")
end

Capybara.javascript_driver = Capybara.default_driver
Capybara.current_driver = Capybara.default_driver
=begin
To run tests on production url and for running any saucelab driver. Replace line 93 and 94 with this:
Capybara.always_include_port = false
Capybara.app_host = "https://appeal-tax-tribunal.service.gov.uk"
=end
Capybara.always_include_port = true
Capybara.app_host = ENV.fetch('CAPYBARA_APP_HOST', "http://#{ENV.fetch('HOSTNAME', 'localhost')}")
Capybara.server_host = ENV.fetch('CAPYBARA_SERVER_HOST', ENV.fetch('HOSTNAME', 'localhost'))
Capybara.server_port = ENV.fetch('CAPYBARA_SERVER_PORT', '3000') unless ENV['CAPYBARA_SERVER_PORT'] == 'random'
