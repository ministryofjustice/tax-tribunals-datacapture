source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.5'

gem 'azure_env_secrets', github: 'ministryofjustice/azure_env_secrets', tag: 'v0.1.3'
gem 'bootsnap',                        '1.7.3', require: false
gem 'devise',                          '~> 4.7.3'
gem "valid_email2",                    '3.6.0'
gem 'glimr-api-client', github: 'ministryofjustice/glimr-api-client', tag: 'v0.4.1'
gem 'govuk_design_system_formbuilder', '~> 2.5'
gem 'govuk_notify_rails',              '~> 2.1'
gem 'jquery-rails',                    '4.4.0'
gem 'mojfile-uploader-api-client',     '~> 0.8'
gem 'nokogiri',                        '~> 1.12.5'
gem 'pg',                              '1.2.3'
gem 'pry-rails',                       '0.3.9'
gem 'puma',                            '~> 5.5'
gem 'rack-attack',                     '~> 5.4.2'
gem 'rails',                           '~> 6.0.3'
gem 'responders',                      '3.0.1'
gem 'sanitize',                        '5.2.3'
gem 'sassc-rails',                     '~> 2.1.2'
gem 'sentry-ruby',                     '~> 4.6'
gem 'sentry-rails',                    '~> 4.6'
gem 'strong_password',                 '~> 0.0.8'
gem 'uglifier',                        '4.2.0'
gem 'virtus',                          '1.0.5'
gem 'zendesk_api',                     '~> 1.28'
gem 'application_insights',            '~> 0.5.6'
gem 'sprockets',                       '3.7.2'

# PDF generation
gem 'wicked_pdf',                      '~> 1.1.0'
gem 'wkhtmltopdf-binary',              '0.12.6.5'
gem "select2-rails",                   '4.0.13'

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
end

group :development, :test do
  gem 'byebug', '11.1.3', platform: :mri
  gem 'dotenv-rails',                  '2.7.6'
  gem 'faker', '~> 1.6', '>= 1.6.3',   '1.9.6'
  gem 'launchy',                       '2.5.0'
  gem 'mutant-rspec',                  '0.10.29'
  gem 'pry-byebug',                    '3.9.0'
  gem 'timecop', '0.9.4'
  gem 'rspec-rails', '5.0.1'
  gem 'rubocop', '~> 1', '1.12.1', require: false
  gem 'rubocop-performance', '1.10.2', require: false
  gem 'rubocop-rspec', '2.2.0', require: false
end

group :test do
  gem 'brakeman', '5.0.4'
  gem 'apparition', '0.6.0'
  gem 'capybara', '3.35.3'
  gem 'capybara-screenshot' , '1.0.25'
  gem 'chromedriver-helper', '~> 2.1'
  gem 'cucumber-rails', '~> 1.5', require: false
  gem 'database_cleaner-active_record'
  gem 'geckodriver-helper', '~> 0.23.0'
  gem 'factory_bot_rails', '6.1.0'
  gem 'phantomjs', '2.1.1.0'
  gem 'poltergeist', '~> 1.18', '>= 1.18.1'
  gem 'rails-controller-testing', '1.0.5'
  gem 'rspec_junit_formatter', '~> 0.4.1'
  gem 'selenium-webdriver', '~> 3.142'
  gem 'simplecov', '0.21.2', require: false
  gem 'simplecov-rcov', '0.2.3'
  gem 'site_prism', '3.7.1'
  gem 'webdrivers', '~> 4.4'
  gem 'webmock', '3.12.2', require: false
end
