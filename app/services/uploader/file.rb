class Uploader
  class File < ApiClient
    EXPIRES_IN = 300 # seconds

    attr_reader :key

    def initialize(key)
      @key = key
    end

    def url
      file_uri = storage.generate_uri("#{ENV.fetch('AZURE_STORAGE_ACCOUNT')}/#{key}")

      signer.signed_uri(
        file_uri,
        false,
        service: 'b',
        permissions: 'r',
        content_disposition: :attachment,
        expiry: expires_at
      ).to_s
    end

    def name
      key.partition('/').last
    end

    private

    def expires_at
      EXPIRES_IN ? (Time.now + EXPIRES_IN).utc.iso8601 : nil
    end

    def signer
      Azure::Storage::Common::Core::Auth::SharedAccessSignature.new(
        ENV.fetch('AZURE_STORAGE_ACCOUNT'),
        ENV.fetch('AZURE_STORAGE_KEY')
      )
    end

    def storage
      Azure::Storage::Blob::BlobService.create(
        storage_account_name: ENV.fetch('AZURE_STORAGE_ACCOUNT'),
        storage_access_key: ENV.fetch('AZURE_STORAGE_KEY')
      )
    end

  end
end