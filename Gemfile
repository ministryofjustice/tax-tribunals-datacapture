source 'https://rubygems.org'

ruby '2.5.3'

gem 'devise', '~> 4.6.0'
gem 'email_validator'
gem 'glimr-api-client', '~> 0.3.2'
gem 'govuk_elements_form_builder', '~> 1.3.0'
gem 'govuk_elements_rails', '~> 3.0.0'
gem 'govuk_frontend_toolkit', '~> 6.0.0'
gem 'govuk_notify_rails', '~> 2.0.0'
gem 'govuk_template'
gem 'jquery-rails'
gem 'mojfile-uploader-api-client', '~> 0.8'
gem 'nokogiri', '~> 1.10.3'
gem 'pg', '~> 0.18'
gem 'pry-rails'
gem 'puma', '~> 3.0'
gem 'rails', '~> 5.0.0'
gem 'responders'
gem 'sanitize'
gem 'sass-rails', '~> 5.0'
gem 'sentry-raven'
gem 'uglifier', '>= 1.3.0'
gem 'virtus'
gem 'zendesk_api', '~> 1.14.4'

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
  gem 'faker'
  gem 'i18n-debug'
  gem 'listen', '~> 3.0.5'
  gem 'ministryofjustice-danger'
  gem 'web-console'
end

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'dotenv-rails'
  gem 'launchy'
  gem 'mutant-rspec'
  gem 'pry-byebug'
  gem 'rspec-rails'
end

group :test do
  gem 'brakeman'
  gem 'capybara', '~> 2.7'
  gem 'capybara-rails', '~> 0.0.2'
  gem 'capybara-screenshot'
  gem 'chromedriver-helper', '~> 2.1'
  gem 'codeclimate-test-reporter', require: nil
  gem 'cucumber-rails', '~> 1.5', require: false
  gem 'geckodriver-helper', '~> 0.23.0'
  gem 'phantomjs'
  gem 'poltergeist', '~> 1.18', '>= 1.18.1'
  gem 'rails-controller-testing'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'selenium-webdriver', '~> 3.142'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'simplecov-rcov'
  gem 'site_prism', '~> 2.9'
  gem 'timecop'
  gem 'webdrivers', '~> 3.9', '>= 3.9.4'
  gem 'webmock', require: false
end
