source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.4'

gem 'azure_env_secrets', github: 'ministryofjustice/azure_env_secrets', tag: 'v0.1.3'
gem 'bootsnap',                        '1.7.3', require: false
gem 'devise',                          '~> 4.7.3'
gem "valid_email2",                    '3.6.0'
gem 'glimr-api-client', github: 'ministryofjustice/glimr-api-client', tag: 'v0.4.1'
gem 'govuk_design_system_formbuilder', '~> 2.5'
gem 'govuk_notify_rails',              '~> 2.1'
gem 'jquery-rails',                    '4.4.0'
gem 'nokogiri',                        '~> 1.14.3'
gem 'pg'                              
gem 'pry-rails'
gem 'puma',                            '~> 5'
gem 'rack-attack',                     '~> 5.4.2'
gem 'rails',                           '~> 6.0.4.6'
gem 'responders',                      '3.0.1'
gem 'sanitize',                        '~> 6.0'                        
gem 'sassc-rails',                     '~> 2.1.2'
gem 'sentry-ruby',                     '~> 5.8'
gem 'sentry-rails',                    '~> 5.8'
gem 'strong_password',                 '~> 0.0.8'
gem 'uglifier',                        '4.2.0'
gem 'virtus',                          '1.0.5'
gem 'zendesk_api',                     '~> 1.28'
gem 'application_insights',            '~> 0.5.6'
gem 'sprockets',                       '3.7.2'
gem 'rest-client',                     '2.0.2'

# Admin
gem 'sidekiq',                         '6.4.1'
gem 'sidekiq-batch',                   '0.1.6'                   
gem 'sidekiq_alive',                   '2.1.4'

# PDF generation
gem "select2-rails",                   '4.0.13'
gem 'grover'

# Azure blob storage
gem 'azure-storage-blob', '~> 2'
gem 'mimemagic', '~> 0.3.3'

# Virus scanning
gem 'clamby'

source 'https://oss:Q7U7p2q2XlpY45kwqjCpXLIPf122rjkR@gem.mutant.dev' do
  gem 'mutant-license',                '0.1.1.2.1739399027284447558325915053311580324856.4'
end

group :production do
  gem 'lograge',                       '0.11.2'
  gem 'logstash-event',                '1.2.02'
end

group :development do
  gem 'better_errors',                 '2.9.1'
  gem 'binding_of_caller',             '1.0.0'
  gem 'i18n-debug',                    '1.2.0'
  gem 'listen', '~> 3.0.5',            '3.0.8'
  gem 'hashdiff', '>= 0.4.0',          '1.0.1'
  gem 'web-console',                   '4.1.0'
  gem 'spring',                        '3.1.1'
  gem 'spring-commands-rspec',         '1.0.4'
  gem "spring-commands-cucumber",      '1.0.1'
end

group :development, :test do
  gem 'byebug', '11.1.3', platform: :mri
  gem 'dotenv-rails',                  '2.7.6'
  gem 'faker',                         '2.20.0'
  gem 'launchy',                       '2.5.0'
  gem 'mutant-rspec',                  '0.10.29'
  gem 'pry-byebug'
  gem 'timecop', '0.9.4'
  gem 'rspec-rails', '5.0.1'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'brakeman'
  gem 'apparition', '0.6.0'
  gem 'capybara', '3.35.3'
  gem 'capybara-screenshot' , '1.0.25'
  gem 'cucumber-rails', '~> 1.5', require: false
  gem 'database_cleaner-active_record'
  gem 'geckodriver-helper', '~> 0.23.0'
  gem 'factory_bot_rails', '6.1.0'
  gem 'phantomjs', '2.1.1.0'
  gem 'poltergeist', '~> 1.18', '>= 1.18.1'
  gem 'rails-controller-testing', '1.0.5'
  gem 'rspec_junit_formatter', '~> 0.4.1'
  gem 'selenium-webdriver'
  gem 'simplecov', '0.21.2', require: false
  gem 'simplecov-rcov', '0.2.3'
  gem 'site_prism', '3.7.1'
  gem 'webmock', '3.12.2', require: false
  gem 'rspec-sidekiq', '3.1.0'
end
