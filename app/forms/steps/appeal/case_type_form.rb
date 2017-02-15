module Steps::Appeal
  class CaseTypeForm < BaseForm
    SHOW_MORE = :_show_more

    attribute :case_type, String

    def self.choices
      [
        CaseType::INCOME_TAX,
        CaseType::VAT,
        CaseType::CAPITAL_GAINS_TAX,
        CaseType::CORPORATION_TAX,
        CaseType::INACCURATE_RETURN_PENALTY,
        CaseType::INFORMATION_NOTICE,
        CaseType::NI_CONTRIBUTIONS,
        SHOW_MORE
      ].map(&:to_s)
    end

    validates_inclusion_of :case_type, in: choices

    private

    def case_type_value?
      case_type && case_type != SHOW_MORE.to_s
    end

    def case_type_value
      CaseType.find_constant(case_type)
    end

    def changed?
      tribunal_case.case_type != case_type_value
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      return true unless case_type_value? && changed?

      tribunal_case.update(
        case_type: case_type_value,
        # The following are dependent attributes that need to be reset
        case_type_other_value: nil,
        challenged_decision: nil,
        dispute_type: nil,
        dispute_type_other_value: nil,
        penalty_level: nil,
        penalty_amount: nil,
        tax_amount: nil
      )
    end
  end
end
