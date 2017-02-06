module Steps::Details
  class HasRepresentativeForm < BaseForm
    attribute :has_representative, String

    def self.choices
      HasRepresentative.values.map(&:to_s)
    end
    validates_inclusion_of :has_representative, in: choices

    private

    def has_representative_value
      HasRepresentative.new(has_representative)
    end

    def changed?
      tribunal_case.has_representative != has_representative_value
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      return true unless changed?

      tribunal_case.update(
        has_representative: has_representative_value,
        # The following are dependent attributes that need to be reset
        representative_individual_first_name: nil,
        representative_individual_last_name: nil,
        representative_organisation_name: nil,
        representative_organisation_registration_number: nil,
        representative_organisation_fao: nil,
        representative_contact_address: nil,
        representative_contact_postcode: nil,
        representative_contact_email: nil,
        representative_contact_phone: nil
      )
    end
  end
end
