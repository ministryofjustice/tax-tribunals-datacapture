module Steps::Cost
  class DisputeTypeForm < BaseForm
    attribute :dispute_type, String

    validates_inclusion_of :dispute_type, in: proc { |record| record.choices }

    def choices
      if include_paye_coding_notice?
        [
          DisputeType::LATE_RETURN_OR_PAYMENT,
          DisputeType::AMOUNT_OF_TAX_OWED,
          DisputeType::PAYE_CODING_NOTICE
        ]
      else
        [
          DisputeType::LATE_RETURN_OR_PAYMENT,
          DisputeType::AMOUNT_OF_TAX_OWED
        ]
      end.map(&:to_s)
    end

    def case_challenged?
      tribunal_case.challenged_decision
    end

    private

    def dispute_type_value
      DisputeType.new(dispute_type)
    end

    def include_paye_coding_notice?
      tribunal_case&.case_type == CaseType::INCOME_TAX
    end

    def changed?
      tribunal_case.dispute_type != dispute_type_value
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      return unless changed?

      tribunal_case.update(
        dispute_type: dispute_type_value,
        # The following are dependent attributes that need to be reset
        penalty_amount: nil
      )
    end
  end
end
