module Steps::Details
  class TaxpayerIndividualDetailsForm < TaxpayerDetailsForm
    attribute :taxpayer_individual_first_name, String
    attribute :taxpayer_individual_last_name, String
    attribute :taxpayer_feedback_consent, Boolean

    validates_presence_of :taxpayer_individual_first_name,
                          :taxpayer_individual_last_name

    def name_fields
      [:taxpayer_individual_first_name, :taxpayer_individual_last_name]
    end

    def show_fao?
      false
    end

    def show_registration_number?
      false
    end

    private

    def persist!
      super(
        taxpayer_individual_first_name: taxpayer_individual_first_name,
        taxpayer_individual_last_name: taxpayer_individual_last_name,
        taxpayer_feedback_consent: taxpayer_feedback_consent
      )
    end
  end
end
