module Steps::Appeal
  class CaseTypeShowMoreForm < BaseForm
    attribute :case_type, String
    attribute :case_type_other_value, String

    def self.choices
      # Make sure we don't show the choices we already had on the previous page
      CaseType.values.map(&:to_s) - CaseTypeForm.choices
    end

    validates_inclusion_of :case_type, in: choices
    validates_presence_of  :case_type_other_value, if: :other_case_type?

    private

    def case_type_value
      CaseType.find_constant(case_type)
    end

    def other_case_type?
      case_type == CaseType::OTHER.to_s
    end

    def changed?
      tribunal_case.case_type != case_type_value ||
        tribunal_case.case_type_other_value != case_type_other_value
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      return true unless changed?

      tribunal_case.update(
        case_type: case_type_value,
        case_type_other_value: case_type_other_value,
        # The following are dependent attributes that need to be reset
        dispute_type: nil,
        penalty_level: nil,
        penalty_amount: nil,
        tax_amount: nil
      )
    end
  end
end
