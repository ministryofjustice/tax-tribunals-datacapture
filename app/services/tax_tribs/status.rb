require 'glimr_api_client'

module TaxTribs
  class Status
    def self.check
      new.check
    end

    def check
      {
        service_status: service_status,
        version: version,
        dependencies: {
          glimr_status: glimr_status,
          database_status: database_status,
          uploader_status: uploader_status
        }
      }
    end

    private

    def version
      ENV['APP_GIT_COMMIT'] || 'unknown'
    end

    def uploader_status
      @uploader_status ||=
        if uploader_client.call && uploader_client.available?
          'ok'
        else
          'failed'
        end
    rescue Errno::ECONNREFUSED
      'failed'
    end

    def uploader_client
      @uploader_client_call ||= MojFileUploaderApiClient::Status.new
    end

    def database_status
      # This will only catch high-level failures.  PG::ConnectionBad gets
      # raised too early in the stack to rescue here.
      @database_status ||= if ActiveRecord::Base.connection
                             'ok'
                           else
                             'failed'
                           end
    rescue PG::ConnectionBad
      'failed'
    end

    def glimr_status
      @glimr_status ||=
        begin
          if GlimrApiClient::Available.call.available?
            'ok'
          end
        rescue GlimrApiClient::Unavailable
          'failed'
        rescue NoMethodError
          'failed'
        end
    end

    def service_status
      if database_status.eql?('ok') &&
          glimr_status.eql?('ok') &&
          uploader_status.eql?('ok')
        'ok'
      else
        'failed'
      end
    end
  end
end
