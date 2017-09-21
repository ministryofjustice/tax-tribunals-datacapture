module Steps::Details
  class TaxpayerTypeForm < BaseForm
    attribute :taxpayer_type, String

    def self.choices
      ContactableEntityType.values.map(&:to_s)
    end
    validates_inclusion_of :taxpayer_type, in: choices

    private

    def taxpayer_type_value
     ContactableEntityType.new(taxpayer_type)
    end

    def changed?
      tribunal_case.taxpayer_type != taxpayer_type_value
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      return true unless changed?

      tribunal_case.update(
        taxpayer_type: taxpayer_type_value,
        # The following are dependent attributes that need to be reset
        taxpayer_individual_first_name: nil,
        taxpayer_individual_last_name: nil,
        taxpayer_organisation_name: nil,
        taxpayer_organisation_registration_number: nil,
        taxpayer_organisation_fao: nil,
        taxpayer_contact_address: nil,
        taxpayer_contact_postcode: nil,
        taxpayer_contact_city: nil,
        taxpayer_contact_country: nil,
        taxpayer_contact_email: nil,
        taxpayer_contact_phone: nil
      )
    end
  end
end
