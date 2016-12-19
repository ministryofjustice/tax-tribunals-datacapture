# Given a tribunal_case object, figure out the cost to the taxpayer
# of lodging the case
class CostDeterminer
  attr_reader :tribunal_case

  def initialize(tribunal_case)
    @tribunal_case = tribunal_case
  end

  def lodgement_fee
    if tribunal_case.penalty_amount
      penalty_lodgement_fee
    elsif tribunal_case.dispute_type
      dispute_type_lodgement_fee
    elsif tribunal_case.case_type
      case_type_lodgement_fee
    else
      # A tribunal_case without case_type is not complete for costing
      raise 'Unable to determine cost of tribunal_case'
    end
  end

  private

  def penalty_lodgement_fee
    case tribunal_case.penalty_amount
    when PenaltyAmount::PENALTY_LEVEL_1
      LodgementFee::FEE_LEVEL_1
    when PenaltyAmount::PENALTY_LEVEL_2
      LodgementFee::FEE_LEVEL_2
    when PenaltyAmount::PENALTY_LEVEL_3
      LodgementFee::FEE_LEVEL_3
    else
      raise 'Unable to determine cost of tribunal_case'
    end
  end

  def dispute_type_lodgement_fee
    case tribunal_case.dispute_type
    when DisputeType::DECISION_ON_ENQUIRY, DisputeType::PAYE_CODING_NOTICE
      LodgementFee::FEE_LEVEL_2
    else
      LodgementFee::FEE_LEVEL_3
    end
  end

  def case_type_lodgement_fee
    # TODO: Update this when we add the case types that don't need dispute_type or penalty_amount
    # but don't have a £200 fee
    LodgementFee::FEE_LEVEL_3
  end
end
