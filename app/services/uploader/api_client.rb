class Uploader
  class ApiClient
    def initialize(*_args)
      @client = Azure::Storage::Blob::BlobService.create(
        storage_account_name: ENV.fetch('AZURE_STORAGE_ACCOUNT'),
        storage_access_key: ENV.fetch('AZURE_STORAGE_KEY')
      )
    end

    protected

    def signer
      @signer ||= Azure::Storage::Common::Core::Auth::SharedAccessSignature.new(
        ENV.fetch('AZURE_STORAGE_ACCOUNT'),
        ENV.fetch('AZURE_STORAGE_KEY')
      )
    end

    private

    def blob_name
      [@collection_ref, @document_key, @filename].compact.join('/')
    end
  end
end
