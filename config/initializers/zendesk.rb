require 'zendesk_api'

ZENDESK_CLIENT = ZendeskAPI::Client.new do |config|
  config.url = 'https://tax-tribunals.zendesk.com/api/v2'
  config.username = ENV['ZENDESK_USERNAME']
  config.token = ENV['ZENDESK_TOKEN']

  require 'logger'
  config.logger = Logger.new('log/zendesk.log')
  config.logger.level = Logger::DEBUG
end
