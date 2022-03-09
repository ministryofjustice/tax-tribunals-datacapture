require 'glimr_api_client'

class GlimrError < StandardError
end

class Admin::GenerateGlimrRecordJob
  include Sidekiq::Job

  def perform(payload)
    logger.info "Creating GLiMR Records with args #{payload.symbolize_keys}"
    res = GlimrApiClient::RegisterNewCase.call(payload.symbolize_keys)
    logger.info res.response_body

    raise GlimrError, "No response provided" unless res.response_body
  end
end
