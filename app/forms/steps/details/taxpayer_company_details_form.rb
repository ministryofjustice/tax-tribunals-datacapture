module Steps::Details
  class TaxpayerCompanyDetailsForm < TaxpayerDetailsForm
    attribute :taxpayer_organisation_name, String
    attribute :taxpayer_organisation_registration_number, String
    attribute :taxpayer_organisation_fao, String

    validates_presence_of :taxpayer_organisation_name,
                          :taxpayer_organisation_fao

    def name_fields
      [:taxpayer_organisation_name]
    end

    def show_fao?
      true
    end

    def show_registration_number?
      true
    end

    private

    def persist!
      super(
        taxpayer_organisation_name:,
        taxpayer_organisation_registration_number:,
        taxpayer_organisation_fao:
      )
    end
  end
end
