module Steps::Details
  class RepresentativeProfessionalStatusForm < BaseForm
    attribute :representative_professional_status, String

    def self.choices
      RepresentativeProfessionalStatus.values.map(&:to_s)
    end
    validates_inclusion_of :representative_professional_status, in: choices

    private

    def representative_professional_status_value
      RepresentativeProfessionalStatus.new(representative_professional_status)
    end

    def changed?
      tribunal_case.representative_professional_status != representative_professional_status_value
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      return true unless changed?

      if representative_professional_status_value == RepresentativeProfessionalStatus::FRIEND_OR_FAMILY
        tribunal_case.update(
          has_representative: HasRepresentative::YES,
          representative_professional_status: representative_professional_status_value,
          representative_type: ContactableEntityType::INDIVIDUAL
        )
      else
        tribunal_case.update(
          has_representative: HasRepresentative::YES,
          representative_professional_status: representative_professional_status_value
        )
      end
    end
  end
end
