class Admin::RestoreImagesJob
  include Sidekiq::Job

  def perform(name)
    puts "starting: #{name}"
    @client = Azure::Storage::Blob::BlobService.create(
      storage_account_name: ENV.fetch('AZURE_STORAGE_ACCOUNT'),
      storage_access_key: ENV.fetch('AZURE_STORAGE_KEY')
    )

    # Extract separate parts
    collection_ref, folder, filename = name.split('/')

    # Get file data
    data = @client.get_blob('uploadedfiles', name)[1]

    # Create a temporary file
    Tempfile.create('tmpfile') do |temp|
      # Fix the file data and save to temp file
      File.binwrite(temp, Base64.decode64(data).force_encoding('utf-8'))

      # Upload new file
      uploader = DocumentUpload.new(
        temp,
        document_key: folder,
        filename: "restored_#{filename}",
        content_type: MimeMagic.by_path(name).try(:type),
        collection_ref: collection_ref
      )

      uploader.upload! if uploader.valid?
      # sleep(1)

      raise UploadError, uploader.errors if uploader.errors?
      puts "finished: #{name}"
    end
  end
end
