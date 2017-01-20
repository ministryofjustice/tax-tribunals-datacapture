module Steps::Cost
  class CaseTypeShowMoreForm < BaseForm
    attribute :case_type, String

    def self.choices
      # Make sure we don't show the choices we already had on the previous page
      CaseType.values.map(&:to_s) - CaseTypeForm.choices
    end

    validates_inclusion_of :case_type, in: choices

    private

    def case_type_value
      CaseType.find_constant(case_type)
    end

    def changed?
      tribunal_case.case_type != case_type_value
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      return true unless changed?

      tribunal_case.update(
        case_type: case_type_value,
        # The following are dependent attributes that need to be reset
        dispute_type: nil,
        penalty_level: nil,
        penalty_amount: nil,
        tax_amount: nil
      )
    end
  end
end
