module Steps::Details
  class OrganisationTaxpayerDetailsForm < TaxpayerDetailsForm
    attribute :taxpayer_company_name, String
    attribute :taxpayer_company_registration_number, String
    attribute :taxpayer_company_fao, String

    validates_presence_of :taxpayer_company_name,
                          :taxpayer_company_registration_number,
                          :taxpayer_company_fao

    private

    def persist!
      super(
        taxpayer_company_name:                taxpayer_company_name,
        taxpayer_company_registration_number: taxpayer_company_registration_number,
        taxpayer_company_fao:                 taxpayer_company_fao
      )
    end
  end
end
