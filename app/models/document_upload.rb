class DocumentUpload
  include Virtus.model

  attribute :tempfile, Object
  attribute :content_type, String
  attribute :original_filename, String

  attr_accessor :errors

  # TODO: decide on the final allowed max size and content types
  #
  MAX_FILE_SIZE = 10.megabyte.freeze
  ALLOWED_CONTENT_TYPES = %w(
    application/pdf
    application/msword
    application/vnd.openxmlformats-officedocument.wordprocessingml.document
    application/vnd.oasis.opendocument.text
    application/rtf
    text/plain
    text/rtf
    image/jpeg
    image/png
    image/tiff
    image/bmp
    image/x-bitmap
  )

  def initialize(obj)
    raise ArgumentError.new('UploadedFile must be an IO object') unless obj.respond_to?(:read)

    self.tempfile = obj.tempfile
    self.content_type = obj.content_type
    self.original_filename = obj.original_filename
    self.errors = []
  end

  def upload!(collection_ref:)
    MojFileUploaderApiClient::AddFile.new(
      collection_ref: collection_ref,
      title: file_name,
      filename: file_name,
      data: file_data
    ).call
  end

  def file_name
    original_filename
  end

  def file_size
    tempfile.size
  end

  def valid?
    validate
    errors.empty?
  end

  private

  def file_data
    Base64.encode64(tempfile.read)
  end

  def validate
    errors.tap do |e|
      e << :file_size if file_size > MAX_FILE_SIZE
      e << :content_type unless content_type.downcase.in?(ALLOWED_CONTENT_TYPES)
    end
  end
end
