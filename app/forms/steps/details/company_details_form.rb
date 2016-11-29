module Steps::Details
  class CompanyDetailsForm < BaseForm
    attribute :taxpayer_company_name, String
    attribute :taxpayer_company_registration_number, String
    attribute :taxpayer_company_fao, String
    attribute :taxpayer_contact_address, String
    attribute :taxpayer_contact_postcode, String
    attribute :taxpayer_contact_email, String
    attribute :taxpayer_contact_phone, String

    validates_presence_of :taxpayer_company_name,
                          :taxpayer_company_registration_number,
                          :taxpayer_company_fao,
                          :taxpayer_contact_address,
                          :taxpayer_contact_postcode,
                          :taxpayer_contact_email,
                          :taxpayer_contact_phone

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case

      tribunal_case.update(
        taxpayer_company_name:                taxpayer_company_name,
        taxpayer_company_registration_number: taxpayer_company_registration_number,
        taxpayer_company_fao:                 taxpayer_company_fao,
        taxpayer_contact_address:             taxpayer_contact_address,
        taxpayer_contact_postcode:            taxpayer_contact_postcode,
        taxpayer_contact_email:               taxpayer_contact_email,
        taxpayer_contact_phone:               taxpayer_contact_phone
      )
    end
  end
end
