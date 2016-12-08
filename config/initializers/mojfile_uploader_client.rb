require 'mojfile_uploader_api_client'

MojFileUploaderApiClient::HttpClient.configure do |client|
  client.base_url = ENV.fetch('MOJ_FILE_UPLOADER', 'http://localhost:9292')
  # client.options = {}
end
