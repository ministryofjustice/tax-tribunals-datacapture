class Uploader
  class UploaderError < RuntimeError
    attr_reader :caused_by

    def initialize(caused_by)
      body, code = caused_by.body, caused_by.code
      @caused_by = caused_by
      super("(#{code}) #{body}")
    end
  end

  class InfectedFileError < RuntimeError; end

  def self.add_file(collection_ref: nil, document_key:, filename:, data:)
    MojFileUploaderApiClient.add_file(
      collection_ref: collection_ref,
      folder: document_key.to_s,
      filename: filename,
      data: data
    )
  rescue MojFileUploaderApiClient::InfectedFileError
    raise InfectedFileError
  rescue MojFileUploaderApiClient::RequestError => e
    raise UploaderError.new(e)
  end

  def self.delete_file(collection_ref:, document_key:, filename:)
    MojFileUploaderApiClient.delete_file(
      collection_ref: collection_ref,
      folder: document_key.to_s,
      filename: filename
    )
  rescue MojFileUploaderApiClient::RequestError => e
    raise UploaderError.new(e)
  end

  def self.list_files(collection_ref:, document_key:)
    MojFileUploaderApiClient.list_files(
      collection_ref: collection_ref,
      folder: document_key.to_s
    )[:files]
  rescue MojFileUploaderApiClient::NotFoundError
    []
  rescue MojFileUploaderApiClient::RequestError => e
    raise UploaderError.new(e)
  end
end
