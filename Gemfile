source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.4'

gem 'azure_env_secrets', github: 'ministryofjustice/azure_env_secrets', tag: 'v0.1.3'
gem 'bootsnap', require: false
gem 'devise', '~> 4.7.3'
gem "valid_email2"
gem 'glimr-api-client', github: 'ministryofjustice/glimr-api-client', tag: 'v0.4.1'
gem 'govuk_design_system_formbuilder', '~> 2.5'
gem 'govuk_notify_rails', '~> 2.1'
gem 'jquery-rails'
gem 'mojfile-uploader-api-client', '~> 0.8'
gem 'nokogiri', '~> 1.12.5'
gem 'pg'
gem 'pry-rails'
gem 'puma', '~> 5.3'
gem 'rack-attack', '~> 5.4.2'
gem 'rails', '~> 6.0.3'
gem 'responders'
gem 'sanitize'
gem 'sassc-rails', '~> 2.1.2'
gem 'sentry-ruby', '~> 4.6'
gem 'sentry-rails', '~> 4.6'
gem 'strong_password', '~> 0.0.8'
gem 'uglifier'
gem 'virtus'
gem 'zendesk_api', '~> 1.28'
gem 'application_insights', '~> 0.5.6'
gem 'sprockets', '3.7.2'

# PDF generation
gem 'wicked_pdf', '~> 1.1.0'
gem 'wkhtmltopdf-binary'
gem "select2-rails", '4.0.13'

source 'https://oss:Q7U7p2q2XlpY45kwqjCpXLIPf122rjkR@gem.mutant.dev' do
  gem 'mutant-license'
end

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
  gem 'mutant-rspec'
  gem 'pry-byebug'
  gem 'timecop'
  gem 'rspec-rails'
  gem 'rubocop', '~> 1', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'brakeman'
  gem 'apparition'
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'chromedriver-helper', '~> 2.1'
  gem 'cucumber-rails', '~> 1.5', require: false
  gem 'database_cleaner-active_record'
  gem 'geckodriver-helper', '~> 0.23.0'
  gem 'factory_bot_rails'
  gem 'phantomjs'
  gem 'poltergeist', '~> 1.18', '>= 1.18.1'
  gem 'rails-controller-testing'
  gem 'rspec_junit_formatter', '~> 0.4.1'
  gem 'selenium-webdriver', '~> 3.142'
  gem 'simplecov', require: false
  gem 'simplecov-rcov'
  gem 'site_prism'
  gem 'webdrivers', '~> 4.4'
  gem 'webmock', require: false
end
