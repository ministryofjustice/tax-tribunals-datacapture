# Given a tribunal_case object, figure out the cost to the taxpayer
# of lodging the case
class CostDeterminer
  attr_reader :tribunal_case

  def initialize(tribunal_case)
    @tribunal_case = tribunal_case
  end

  def lodgement_fee
    case tribunal_case.case_type
    when CaseType::INCOME_TAX
      income_tax_lodgement_fee
    when CaseType::VAT
      vat_lodgement_fee
    when CaseType::APN_PENALTY,
         CaseType::CLOSURE_NOTICE,
         CaseType::INFORMATION_NOTICE,
         CaseType::INACCURATE_RETURN,
         CaseType::REQUEST_PERMISSION_FOR_REVIEW,
         CaseType::OTHER
      LodgementFee::FEE_LEVEL_2
    else
      raise "Unable to determine cost of tribunal_case"
    end
  end

  private

  def vat_lodgement_fee
    case tribunal_case.dispute_type
    when DisputeType::AMOUNT_OF_TAX_OWED
      LodgementFee::FEE_LEVEL_3
    when DisputeType::LATE_RETURN_OR_PAYMENT
      penalty_amount_tribunal_case_cost
    else
      raise "Unable to determine cost of VAT tribunal_case"
    end
  end

  def income_tax_lodgement_fee
    case tribunal_case.dispute_type
    when DisputeType::PAYE_CODING_NOTICE
      LodgementFee::FEE_LEVEL_2
    when DisputeType::AMOUNT_OF_TAX_OWED
      LodgementFee::FEE_LEVEL_3
    when DisputeType::LATE_RETURN_OR_PAYMENT
      penalty_amount_tribunal_case_cost
    else
      raise "Unable to determine cost of income tax tribunal_case"
    end
  end

  def penalty_amount_tribunal_case_cost
    case tribunal_case.penalty_amount
    when PenaltyAmount::PENALTY_LEVEL_1
      LodgementFee::FEE_LEVEL_1
    when PenaltyAmount::PENALTY_LEVEL_2
      LodgementFee::FEE_LEVEL_2
    when PenaltyAmount::PENALTY_LEVEL_3
      LodgementFee::FEE_LEVEL_3
    else
      raise "Unable to determine cost of penalty tribunal_case"
    end
  end
end
