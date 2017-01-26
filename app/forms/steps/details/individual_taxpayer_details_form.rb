module Steps::Details
  class IndividualTaxpayerDetailsForm < TaxpayerDetailsForm
    attribute :taxpayer_individual_name, String

    validates_presence_of :taxpayer_individual_name

    private

    def persist!
      super(
        taxpayer_individual_name: taxpayer_individual_name
      )
    end
  end
end
