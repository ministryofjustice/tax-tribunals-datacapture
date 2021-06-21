module Steps::Hardship
  class HardshipContactHmrcController < Steps::HardshipStepController
    CONTACT_HMRC_URL = "https://www.gov.uk/hmrc-internal-manuals/appeals-reviews-and-tribunals-guidance".freeze

    def edit; end

    def update
      current_tribunal_case.destroy
      redirect_to CONTACT_HMRC_URL
    end
  end
end
