class Uploader
  class AddFile < ApiClient
    UPLOAD_RETRIES = 2

    def initialize(collection_ref:, document_key:, filename:, data:)
      super
      @collection_ref = collection_ref
      @document_key = document_key
      @filename = filename
      @data = data
      @retries = 0
    end

    def call
      validate_arguments
      sanitize_filename
      scan_file
      upload
    end

    private

    def scan_file
      return if VirusScanner.scan_clear?(@filename, @data)

      log_infected_file
      raise Uploader::InfectedFileError
    end

    def upload
      @client.create_block_blob(
        ENV.fetch('AZURE_STORAGE_CONTAINER'),
        blob_name,
        @data,
        options: { content_type: content_type }
      )
    rescue KeyError => err # e.g. Env not found
      raise KeyError, err
    rescue StandardError => err
      repeat_or_raise(err)
    end

    def content_type
      type = MimeMagic.by_path(@filename).try(:type)
      raise ArgumentError, 'File content type not recognised' unless type
      type
    end

    def sanitize_filename
      @filename = @filename.unicode_normalize(:nfkd)
      @filename = Sanitize.fragment(@filename)
        .gsub(/[^0-9a-zA-Z.\-_]/, '')
    end

    def validate_arguments
      raise Uploader::UploaderError, 'Filename must be provided' unless @filename.present?
      raise Uploader::UploaderError, 'File data must be provided' unless @data.present?
    end

    def repeat_or_raise(err)
      if @retries <= UPLOAD_RETRIES
        log_retry_error
        sleep @retries
        @retries += 1
        upload
      else
        log_request_error(err)
        backup_or_raise(err)
      end
    end

    def backup_or_raise(err)
      raise Uploader::UploaderError, err unless BackupNoa.is_noa?(@filename)

      BackupNoa.keep_noa(
        collection_ref: @collection_ref,
        folder: @document_key.to_s,
        filename: @filename,
        data: @data
      )
    end

    def log_infected_file
      Rails.logger.tagged('add_file') { Rails.logger.warn("Uploader::InfectedFileError: #{@filename}") }
    end

    def log_retry_error
      Rails.logger.tagged('add_file') {
        Rails.logger.warn('Uploader::RequestError::Retry': {retry_counter: @retries})
      }
    end

    def log_request_error(err)
      Rails.logger.tagged('add_file') {
        Rails.logger.warn('Uploader::RequestError': {error: err.inspect, backtrace: err.backtrace})
      }
    end
  end
end


