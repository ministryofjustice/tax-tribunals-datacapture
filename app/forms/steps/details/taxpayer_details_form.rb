module Steps::Details
  class TaxpayerDetailsForm < BaseForm
    attribute :taxpayer_contact_address, String
    attribute :taxpayer_contact_postcode, String
    attribute :taxpayer_contact_email, String
    attribute :taxpayer_contact_phone, String

    validates_presence_of :taxpayer_contact_address,
                          :taxpayer_contact_postcode,
                          :taxpayer_contact_email,
                          :taxpayer_contact_phone

    private

    def persist!(additional_attributes)
      raise 'No TribunalCase given' unless tribunal_case

      tribunal_case.update({
        taxpayer_contact_address:  taxpayer_contact_address,
        taxpayer_contact_postcode: taxpayer_contact_postcode,
        taxpayer_contact_email:    taxpayer_contact_email,
        taxpayer_contact_phone:    taxpayer_contact_phone
      }.merge(additional_attributes))
    end
  end
end
