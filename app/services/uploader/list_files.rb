class Uploader
  class ListFiles < ApiClient
    def initialize(collection_ref: nil, document_key: nil)
      super
      @collection_ref = collection_ref
      @document_key = document_key
    end

    def call
      files = @client.list_blobs(
        ENV.fetch('AZURE_STORAGE_CONTAINER'),
        prefix:
      )
      log_files_empty if files.empty?

      files
    rescue KeyError => err # e.g. Env not found
      raise KeyError, err
    rescue StandardError => err
      log_uploader_error(err)
      raise Uploader::UploaderError, err
    end

    private

    def prefix
      "#{[@collection_ref, @document_key]
        .compact.join('/')}/"
    end

    def log_files_empty
      Rails.logger.tagged('list_files') {
        Rails.logger.warn("NotFoundError")
      }
    end

    def log_uploader_error(err)
      Rails.logger.tagged('list_files') {
        Rails.logger.warn('Uploader::RequestError': {
                            error: err.inspect, backtrace: err.backtrace
                          })
      }
    end
  end
end
