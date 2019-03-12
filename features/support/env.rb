require 'cucumber/rails'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'capybara-screenshot/cucumber'
require 'selenium-webdriver'

require_relative './page_objects/base_page'

Dir[File.dirname(__FILE__) + '/page_objects/**/*.rb'].each { |f| require f }

ActionController::Base.allow_rescue = false
