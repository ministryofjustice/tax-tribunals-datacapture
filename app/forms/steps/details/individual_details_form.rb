module Steps::Details
  class IndividualDetailsForm < BaseForm
    attribute :taxpayer_individual_name, String
    attribute :taxpayer_contact_address, String
    attribute :taxpayer_contact_postcode, String
    attribute :taxpayer_contact_email, String
    attribute :taxpayer_contact_phone, String

    validates_presence_of :taxpayer_individual_name,
                          :taxpayer_contact_address,
                          :taxpayer_contact_postcode,
                          :taxpayer_contact_email,
                          :taxpayer_contact_phone

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case

      tribunal_case.update(
        taxpayer_individual_name:  taxpayer_individual_name,
        taxpayer_contact_address:  taxpayer_contact_address,
        taxpayer_contact_postcode: taxpayer_contact_postcode,
        taxpayer_contact_email:    taxpayer_contact_email,
        taxpayer_contact_phone:    taxpayer_contact_phone
      )
    end
  end
end
