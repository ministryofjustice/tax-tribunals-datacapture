class Uploader
  class File < ApiClient
    EXPIRES_IN = 300 # seconds

    attr_reader :key

    def initialize(key)
      super
      @key = key
    end

    def url
      file_uri = @client.generate_uri("#{ENV.fetch('AZURE_STORAGE_CONTAINER')}/#{key}")

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

    # Allow two File objects to be compared
    def ==(other)
      key == other.key
    end

    def hash
      key.hash
    end

    private

    def expires_at
      (Time.now + EXPIRES_IN).utc.iso8601
    end
  end
end