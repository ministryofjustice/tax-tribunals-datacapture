module Steps::Details
  class TaxpayerIndividualDetailsForm < TaxpayerDetailsForm
    attribute :taxpayer_individual_name, String

    validates_presence_of :taxpayer_individual_name

    def name_fields
      [:taxpayer_individual_name]
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
        taxpayer_individual_name: taxpayer_individual_name
      )
    end
  end
end
