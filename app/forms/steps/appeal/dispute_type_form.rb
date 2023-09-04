module Steps::Appeal
  class DisputeTypeForm < BaseForm
    attribute :dispute_type, String
    attribute :dispute_type_other_value, String

    validates_inclusion_of :dispute_type, in: proc { |record| record.choices }
    validates_presence_of  :dispute_type_other_value, if: :other_dispute_type?

    def choices
      case tribunal_case&.case_type
      when CaseType::DOTAS_PENALTY
        dotas_penalty_choices
      when CaseType::INFORMATION_NOTICE
        information_notice_choices
      when CaseType::INCOME_TAX
        income_tax_choices
      when CaseType::MONEY_LAUNDERING_DECISIONS
        money_laundering_choices
      when CaseType::VAT
        vat_choices
      else
        default_choices
      end.map(&:to_s)
    end

    private

    def dotas_penalty_choices
      [
        DisputeType::PENALTY,
        DisputeType::OTHER
      ]
    end

    def information_notice_choices
      [
        DisputeType::PENALTY,
        DisputeType::INFORMATION_NOTICE,
        DisputeType::OTHER
      ]
    end

    def income_tax_choices
      [
        DisputeType::PENALTY,
        DisputeType::AMOUNT_OF_TAX_OWED_BY_HMRC,
        DisputeType::AMOUNT_OF_TAX_OWED_BY_TAXPAYER,
        DisputeType::AMOUNT_AND_PENALTY,
        DisputeType::PAYE_CODING_NOTICE,
        DisputeType::OTHER
      ]
    end

    def money_laundering_choices
      [
        DisputeType::PENALTY,
        DisputeType::REFUSAL_TO_REGISTER_APPLICANT,
        DisputeType::CANCELLATION_OF_REGISTRATION,
        DisputeType::OTHER
      ]
    end

    def vat_choices
      [
        DisputeType::PENALTY,
        DisputeType::AMOUNT_OF_TAX_OWED_BY_HMRC,
        DisputeType::AMOUNT_OF_TAX_OWED_BY_TAXPAYER,
        DisputeType::AMOUNT_AND_PENALTY,
        DisputeType::SECURITY_NOTICE,
        DisputeType::REGISTRATION,
        DisputeType::OTHER
      ]
    end

    def default_choices
      [
        DisputeType::PENALTY,
        DisputeType::AMOUNT_OF_TAX_OWED_BY_HMRC,
        DisputeType::AMOUNT_OF_TAX_OWED_BY_TAXPAYER,
        DisputeType::AMOUNT_AND_PENALTY,
        DisputeType::OTHER
      ]
    end

    def dispute_type_value
      DisputeType.new(dispute_type)
    end

    def other_dispute_type?
      dispute_type == DisputeType::OTHER.to_s
    end

    def changed?
      tribunal_case.dispute_type != dispute_type_value ||
        tribunal_case.dispute_type_other_value != dispute_type_other_value
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      return true unless changed?

      tribunal_case.update(
        dispute_type: dispute_type_value,
        dispute_type_other_value:,
        # The following are dependent attributes that need to be reset
        penalty_level: nil,
        penalty_amount: nil,
        tax_amount: nil
      )
    end
  end
end
