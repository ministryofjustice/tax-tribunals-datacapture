require 'mojfile_uploader_api_client'

MojFileUploaderApiClient::HttpClient.configure do |client|
  client.base_url = ENV.fetch('MOJ_FILE_UPLOADER_ENDPOINT')
  # client.options = {}
end
