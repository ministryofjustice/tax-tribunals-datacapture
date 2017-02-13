module Steps::Details
  class RepresentativeIsLegalProfessionalForm < BaseForm
    attribute :representative_is_legal_professional, String

    def self.choices
      RepresentativeIsLegalProfessional.values.map(&:to_s)
    end
    validates_inclusion_of :representative_is_legal_professional, in: choices

    private

    def representative_is_legal_professional_value
      RepresentativeIsLegalProfessional.new(representative_is_legal_professional)
    end

    def changed?
      tribunal_case.representative_is_legal_professional != representative_is_legal_professional_value
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      return true unless changed?

      tribunal_case.update(
        representative_is_legal_professional: representative_is_legal_professional_value
      )
    end
  end
end
