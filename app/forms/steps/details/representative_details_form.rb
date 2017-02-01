module Steps::Details
  class RepresentativeDetailsForm < BaseForm
    attribute :representative_contact_address, String
    attribute :representative_contact_postcode, String
    attribute :representative_contact_email, String
    attribute :representative_contact_phone, String

    validates_presence_of :representative_contact_address,
                          :representative_contact_postcode,
                          :representative_contact_email

    private

    def persist!(additional_attributes)
      raise 'No TribunalCase given' unless tribunal_case

      tribunal_case.update({
        representative_contact_address:  representative_contact_address,
        representative_contact_postcode: representative_contact_postcode,
        representative_contact_email:    representative_contact_email,
        representative_contact_phone:    representative_contact_phone
      }.merge(additional_attributes))
    end
  end
end
