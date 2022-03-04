require 'glimr_api_client'

class Admin::GenerateGlimrRecordJob
  include Sidekiq::Job

  def perform(payload)
    puts "Creating GLiMR Records with args #{payload.symbolize_keys}"
    GlimrApiClient::RegisterNewCase.call(payload.symbolize_keys)
  end

end
