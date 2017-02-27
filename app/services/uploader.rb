class Uploader
  class UploaderError < RuntimeError; end
  class InfectedFileError < UploaderError; end

  def self.add_file(collection_ref: nil, document_key:, filename:, data:)
    MojFileUploaderApiClient.add_file(
      collection_ref: collection_ref,
      folder: document_key.to_s,
      filename: filename,
      data: data
    )
  rescue MojFileUploaderApiClient::InfectedFileError
    raise InfectedFileError
  rescue MojFileUploaderApiClient::RequestError
    raise UploaderError
  end

  def self.delete_file(collection_ref:, document_key:, filename:)
    MojFileUploaderApiClient.delete_file(
      collection_ref: collection_ref,
      folder: document_key.to_s,
      filename: filename
    )
  rescue MojFileUploaderApiClient::RequestError
    raise UploaderError
  end

  def self.list_files(collection_ref:, document_key:)
    MojFileUploaderApiClient.list_files(
      collection_ref: collection_ref,
      folder: document_key.to_s
    )[:files]
  rescue MojFileUploaderApiClient::NotFoundError
    []
  rescue MojFileUploaderApiClient::RequestError
    raise UploaderError
  end
end
