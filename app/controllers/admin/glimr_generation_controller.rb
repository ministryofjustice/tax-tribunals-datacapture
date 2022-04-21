require 'glimr_api_client'

class Admin::GlimrGenerationController < AdminController
  def new; end

  # Will need to be an ajax call
  def create
    num = params['number-of-records'].to_i
    if (!num.is_a? Numeric) || (num < 1)
      @errors = { number_of_records: "Not a valid number" }
      render :new and return
    end

    queue_creation(num)
    flash[:notice] = 'success'
    render :new
  end

  private

  def payload
    @payload ||= {
      jurisdictionId: jurisdiction_id,
    }.merge(generator_params)
  end

  def jurisdiction_id
    GlimrApiClient::RegisterNewCase::TRIBUNAL_JURISDICTION_ID
  end

  def generator_params
    params.slice(
      :onlineMappingCode,
      :contactFirstName,
      :contactLastName,
      :contactPreference
    ).permit(:onlineMappingCode, :contactFirstName,
             :contactLastName, :contactPreference)
  end

  def queue_creation(num)
    delay = 20.seconds
    batch = Sidekiq::Batch.new
    batch.description = "Glimr batch @ #{Time.now}, n = #{num}"
    batch.on(:complete, Admin::GenerateGlimrRecordsComplete, to: params[:email])
    batch.jobs do
      num.times do |index|
        Admin::GenerateGlimrRecordJob.perform_in(index * delay, payload)
      end
    end
    logger.info "Queued jobs"
  end
end
