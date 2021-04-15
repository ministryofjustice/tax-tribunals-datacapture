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
  chrome_options = Selenium::WebDriver::Chrome::Options.new(args: ['headless', 'disable-gpu', 'window-size=1920,1080'])
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
  browser = {:browserName=>"chrome", :name=>"MAC_CHROME_LATEST", :platform=>"OS X 10.12", :version=>"latest"}
  Capybara::Selenium::Driver.new(app, browser: :remote, url: "http://#{ENV['SAUCE_USERNAME']}:#{ENV['SAUCE_ACCESS_KEY']}@ondemand.saucelabs.com:80/wd/hub", desired_capabilities: browser)
end

Capybara.register_driver :firefox_saucelabs do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile['browser.cache.disk.enable'] = false
  profile['browser.cache.memory.enable'] = false
  caps = Selenium::WebDriver::Remote::Capabilities.firefox(idle_timeout: 150)
  Capybara::Selenium::Driver.new(app, browser: :remote, desired_capabilities: caps, url: "http://#{ENV['SAUCE_USERNAME']}:#{ENV['SAUCE_ACCESS_KEY']}@ondemand.saucelabs.com:80/wd/hub")
end

Capybara.register_driver :internet_explorer_saucelabs do |app|
  browser = {:browserName=>"MicrosoftEdge", :name=>"IEEdge_LATEST", :platform=>"Windows 10", :version=>"latest"}
  Capybara::Selenium::Driver.new(app, browser: :remote, desired_capabilities: browser, url: "http://#{ENV['SAUCE_USERNAME']}:#{ENV['SAUCE_ACCESS_KEY']}@ondemand.saucelabs.com:80/wd/hub")
end

Capybara.register_driver :safari_saucelabs do |app|
  Capybara::Selenium::Driver.new(app, browser: :safari, url: "http://#{ENV['SAUCE_USERNAME']}:#{ENV['SAUCE_ACCESS_KEY']}@ondemand.saucelabs.com:80/wd/hub" )
end

Capybara.javascript_driver = Capybara.default_driver
Capybara.current_driver = Capybara.default_driver
Capybara.always_include_port = true
Capybara.app_host = ENV.fetch('CAPYBARA_APP_HOST', "http://#{ENV.fetch('HOSTNAME', 'localhost')}")
Capybara.server_host = ENV.fetch('CAPYBARA_SERVER_HOST', ENV.fetch('HOSTNAME', 'localhost'))
Capybara.server_port = ENV.fetch('CAPYBARA_SERVER_PORT', '3000') unless ENV['CAPYBARA_SERVER_PORT'] == 'random'
