module Steps::Details
  class OrganisationTaxpayerDetailsForm < TaxpayerDetailsForm
    attribute :taxpayer_organisation_name, String
    attribute :taxpayer_organisation_registration_number, String
    attribute :taxpayer_organisation_fao, String

    validates_presence_of :taxpayer_organisation_name,
                          :taxpayer_organisation_registration_number,
                          :taxpayer_organisation_fao

    private

    def persist!
      super(
        taxpayer_organisation_name:                taxpayer_organisation_name,
        taxpayer_organisation_registration_number: taxpayer_organisation_registration_number,
        taxpayer_organisation_fao:                 taxpayer_organisation_fao
      )
    end
  end
end
