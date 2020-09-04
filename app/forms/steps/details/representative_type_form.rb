module Steps::Details
  class RepresentativeTypeForm < BaseForm
    attribute :representative_type, String

    def self.choices
      ContactableEntityType.values
    end
    validates_inclusion_of :representative_type, in: choices.map(&:to_s)

    private

    def representative_type_value
      ContactableEntityType.new(representative_type)
    end

    def changed?
      tribunal_case.representative_type != representative_type_value
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      return true unless changed?

      tribunal_case.update(
        representative_type: representative_type_value,
        # The following are dependent attributes that need to be reset
        representative_individual_first_name: nil,
        representative_individual_last_name: nil,
        representative_organisation_name: nil,
        representative_organisation_registration_number: nil,
        representative_organisation_fao: nil,
        representative_contact_address: nil,
        representative_contact_postcode: nil,
        representative_contact_city: nil,
        representative_contact_country: nil,
        representative_contact_email: nil,
        representative_contact_phone: nil
      )
    end
  end
end
