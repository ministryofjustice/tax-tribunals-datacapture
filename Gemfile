source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.7'

gem 'azure_env_secrets', github: 'ministryofjustice/azure_env_secrets', tag: 'v0.1.3'
gem 'bootsnap', require: false
gem 'devise', '~> 4.7.1'
gem 'email_validator'
gem 'glimr-api-client', '~> 0.3.2'
gem 'govuk_design_system_formbuilder', '~> 2.1.4'
gem 'govuk_notify_rails', '~> 2.0.0'
gem 'jquery-rails'
gem 'mojfile-uploader-api-client', '~> 0.8'
gem 'nokogiri', '~> 1.10.5'
gem 'pg'
gem 'pry-rails'
gem 'puma', '~> 4.3.5'
gem 'rack-attack', '~> 5.4.2'
gem 'rails', '~> 6.0.3'
gem 'responders'
gem 'sanitize'
gem 'sassc-rails', '~> 2.1.2'
gem 'sentry-raven'
gem 'strong_password', '~> 0.0.8'
gem 'uglifier'
gem 'virtus'
gem 'zendesk_api', '~> 1.14.4'
gem 'application_insights', '~> 0.5.6'

# PDF generation
gem 'wicked_pdf', '~> 1.1.0'
gem 'wkhtmltopdf-binary'

group :production do
  gem 'lograge'
  gem 'logstash-event'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'i18n-debug'
  gem 'listen', '~> 3.0.5'
  gem 'hashdiff', '>= 0.4.0'
  gem 'web-console'
end

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'dotenv-rails'
  gem 'faker', '~> 1.6', '>= 1.6.3'
  gem 'launchy'
  gem 'mutant-rspec', '< 0.9'
  gem 'pry-byebug'
  gem 'rspec-rails'
end

group :test do
  gem 'brakeman'
  gem 'apparition'
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'chromedriver-helper', '~> 2.1'
  gem 'cucumber-rails', '~> 1.5', require: false
  gem 'geckodriver-helper', '~> 0.23.0'
  gem 'rails-controller-testing'
  gem 'rspec_junit_formatter', '~> 0.4.1'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rspec', require: false
  gem 'selenium-webdriver', '~> 3.142'
  gem 'simplecov', require: false
  gem 'simplecov-rcov'
  gem 'site_prism'
  gem 'webdrivers', '~> 4.4'
  gem 'webmock', require: false
end
