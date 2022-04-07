class Uploader
  class UploaderError < RuntimeError; end

  class InfectedFileError < RuntimeError; end

  class NotFoundError < RuntimeError; end

  def self.add_file(**args)
    Uploader::AddFile.new(
      collection_ref: args[:collection_ref],
      document_key:   args[:document_key],
      filename:       args[:filename],
      data:           args[:data]
    ).call
  end

  def self.list_files(**args)
    Uploader::ListFiles.new(
      collection_ref: args[:collection_ref],
      document_key:   args[:document_key]
    ).call
  end

  def self.delete_file(**args)
    Uploader::DeleteFile.new(
      collection_ref: args[:collection_ref],
      document_key:   args[:document_key],
      filename:       args[:filename],
    ).call
  end
end