class DocumentUpload
  include Virtus.model

  attribute :tempfile, Object
  attribute :content_type, String
  attribute :original_filename, String
  attribute :collection_ref, String

  attr_accessor :errors

  # TODO: decide on the final allowed max size and content types
  #
  MAX_FILE_SIZE = 10.megabyte.freeze
  ALLOWED_CONTENT_TYPES = %w(
    application/pdf
    application/msword
    application/vnd.ms-excel
    application/vnd.openxmlformats-officedocument.wordprocessingml.document
    application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
    application/vnd.oasis.opendocument.text
    application/rtf
    text/plain
    text/rtf
    text/csv
    image/jpeg
    image/png
    image/tiff
    image/bmp
    image/x-bitmap
  )

  def initialize(obj, content_type: nil, filename: nil, collection_ref: nil)
    raise ArgumentError.new('Must receive an IO object') unless obj.respond_to?(:read)

    self.tempfile = obj.respond_to?(:tempfile) ? obj.tempfile : obj
    self.content_type = content_type || obj.content_type
    self.original_filename = filename || obj.original_filename
    self.collection_ref = collection_ref
    self.errors = []
  end

  def upload!(collection_ref: nil)
    response = MojFileUploaderApiClient::AddFile.new(
      collection_ref: collection_ref || self.collection_ref,
      title: file_name,
      filename: file_name,
      data: file_data
    ).call

    add_error(:response_error) if response.error?
    response
  end

  def file_name
    original_filename
  end

  def encoded_file_name
    Base64.encode64(file_name)
  end

  def file_size
    tempfile.size
  end

  def valid?
    validate
    errors.empty?
  end

  def errors?
    errors.any?
  end

  # Used by Rails responders when responding with JSON.
  def to_hash
    {name: file_name, encoded_name: encoded_file_name, collection_ref: collection_ref}
  end

  private

  # We encode the file data in order to post it to the MOJ File Uploader app endpoint.
  #
  def file_data
    Base64.encode64(tempfile.read)
  end

  def validate
    add_error(:file_size) if file_size > MAX_FILE_SIZE
    add_error(:content_type) unless content_type.downcase.in?(ALLOWED_CONTENT_TYPES)
  end

  def add_error(code)
    errors << code unless errors.include?(code)
  end
end
