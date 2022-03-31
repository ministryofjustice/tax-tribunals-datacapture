# frozen_string_literal: true

module Uploader
  module AzureBlobStorage
    def client
      Azure::Storage::Blob::BlobService.create(
        storage_account_name: ENV.fetch('AZURE_STORAGE_ACCOUNT'),
        storage_access_key:   ENV.fetch('AZURE_STORAGE_KEY')
        )
    end

    private

    def container_name
      ENV.fetch('AZURE_STORAGE_CONTAINER_NAME')
    end

    def blob_name
      [collection, folder, filename].compact.join('/')
    end
  end
end
