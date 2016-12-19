# Given a tribunal_case object, figure out the cost to the taxpayer
# of lodging the case
class CostDeterminer
  attr_reader :tribunal_case

  def initialize(tribunal_case)
    @tribunal_case = tribunal_case
  end

  def lodgement_fee
    case tribunal_case.case_type
    when CaseType::INCOME_TAX, CaseType::VAT
      tax_lodgement_fee
    when CaseType::INACCURATE_RETURN_PENALTY
      penalty_lodgement_fee
    when CaseType::OTHER
      LodgementFee::FEE_LEVEL_2
    else
      raise "Unable to determine cost of tribunal_case"
    end
  end

  private

  def tax_lodgement_fee
    case tribunal_case.dispute_type
    when DisputeType::AMOUNT_OF_TAX, DisputeType::AMOUNT_AND_PENALTY
      LodgementFee::FEE_LEVEL_3
    when DisputeType::PENALTY
      penalty_lodgement_fee
    when DisputeType::DECISION_ON_ENQUIRY
      LodgementFee::FEE_LEVEL_2
    when DisputeType::PAYE_CODING_NOTICE
      LodgementFee::FEE_LEVEL_2
    when DisputeType::OTHER
      LodgementFee::FEE_LEVEL_3
    else
      raise "Unable to determine cost of tribunal_case"
    end
  end

  def penalty_lodgement_fee
    case tribunal_case.penalty_amount
    when PenaltyAmount::PENALTY_LEVEL_1
      LodgementFee::FEE_LEVEL_1
    when PenaltyAmount::PENALTY_LEVEL_2
      LodgementFee::FEE_LEVEL_2
    when PenaltyAmount::PENALTY_LEVEL_3
      LodgementFee::FEE_LEVEL_3
    else
      raise "Unable to determine cost of tribunal_case"
    end
  end
end
