class Uploader
  UPLOAD_RETRIES = 2

  class UploaderError < RuntimeError
    attr_reader :caused_by

    def initialize(caused_by)
      @caused_by = caused_by

      if caused_by.is_a?(MojFileUploaderApiClient::RequestError)
        super("#{caused_by.message} - (#{caused_by.code}) #{caused_by.body}")
      else
        super
      end
    end
  end

  class InfectedFileError < RuntimeError; end

  def self.add_file(collection_ref: nil, document_key:, filename:, data:, retry_counter: 0)
    Rails.logger.tagged('add_file') {
      Rails.logger.info({filename: filename, collection_ref: collection_ref, folder: document_key.to_s})
    }

    MojFileUploaderApiClient.add_file(
      collection_ref: collection_ref,
      folder: document_key.to_s,
      filename: filename,
      data: data
    )
  rescue MojFileUploaderApiClient::InfectedFileError
    Rails.logger.tagged('add_file') { Rails.logger.warn("InfectedFileError: #{filename}") }
    raise InfectedFileError
  rescue => e
    if retry_counter <= UPLOAD_RETRIES
      sleep retry_counter
      Rails.logger.tagged('add_file') {
        Rails.logger.warn('MojFileUploaderApiClient::RequestError::Retry': {retry_counter: retry_counter})
      }
      self.add_file(collection_ref: collection_ref,
                    document_key: document_key,
                    filename: filename,
                    data: data,
                    retry_counter: retry_counter + 1)
    else
      Rails.logger.tagged('add_file') {
        Rails.logger.warn('MojFileUploaderApiClient::RequestError': {error: e.inspect, backtrace: e.backtrace})
      }
      raise UploaderError.new(e)
    end
  end

  def self.delete_file(collection_ref:, document_key:, filename:)
    Rails.logger.tagged('delete_file') {
      Rails.logger.info({filename: filename, collection_ref: collection_ref, folder: document_key.to_s})
    }

    MojFileUploaderApiClient.delete_file(
      collection_ref: collection_ref,
      folder: document_key.to_s,
      filename: filename
    )
  rescue => e
    Rails.logger.tagged('delete_file') {
      Rails.logger.warn('MojFileUploaderApiClient::RequestError': {error: e.inspect, backtrace: e.backtrace})
    }
    raise UploaderError.new(e)
  end

  def self.list_files(collection_ref:, document_key:)
    MojFileUploaderApiClient.list_files(
      collection_ref: collection_ref,
      folder: document_key.to_s
    )[:files]
  rescue MojFileUploaderApiClient::NotFoundError
    Rails.logger.tagged('list_files') { Rails.logger.warn("NotFoundError") }
    []
  rescue => e
    Rails.logger.tagged('list_files') {
      Rails.logger.warn('MojFileUploaderApiClient::RequestError': {error: e.inspect, backtrace: e.backtrace})
    }
    raise UploaderError.new(e)
  end
end
