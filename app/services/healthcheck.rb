require 'glimr_api_client'
class Healthcheck
  def self.check
    new.check
  end

  def check
    {
      service_status: service_status,
      dependencies: {
        glimr_status: glimr_status,
        database_status: database_status,
        uploader_status: uploader_status
      }
    }
  end

  private

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
        if GlimrApiClient::Available.call.available?.eql?(true)
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
