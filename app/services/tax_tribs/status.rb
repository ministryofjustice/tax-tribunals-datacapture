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
      # This has been manually checked in a demo app in a docker container running
      # ruby:latest with Docker 1.12. Ymmv, however; in particular it may not
      # work on alpine-based containers. It is mocked at the method level in the
      # specs, so it is possible to simply comment the call out if there are
      # issues with it.
      `git rev-parse HEAD`.chomp
    end

    def uploader_status
      @uploader_status ||=
        if uploader_client.call && uploader_client.available?
          'ok'
        else
          'failed'
        end
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
    end

    def glimr_status
      @glimr_status ||=
        begin
          if GlimrApiClient::Available.call.available?
            'ok'
          end
        rescue GlimrApiClient::Unavailable
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
