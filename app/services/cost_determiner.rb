# Given a tribunal_case object, figure out the cost to the taxpayer
# of lodging the case
class CostDeterminer
  attr_reader :tribunal_case

  def initialize(tribunal_case)
    @tribunal_case = tribunal_case
  end

  def lodgement_fee
    case tribunal_case.case_type&.case_type
    when 'income_tax'
      income_tax_lodgement_fee
    when 'vat'
      vat_lodgement_fee
    when 'apn_penalty',
         'closure_notice',
         'information_notice',
         'inaccurate_return',
         'request_permission_for_review',
         'other'
      LodgementFee.fee_level_2
    else
      raise "Unable to determine cost of tribunal_case"
    end
  end

  private

  def vat_lodgement_fee
    case tribunal_case.dispute_type
    when 'amount_of_tax_owed'
      LodgementFee.fee_level_3
    when 'late_return_or_payment'
      penalty_amount_tribunal_case_cost
    else
      raise "Unable to determine cost of VAT tribunal_case"
    end
  end

  def income_tax_lodgement_fee
    case tribunal_case.dispute_type
    when 'paye_coding_notice'
      LodgementFee.fee_level_2
    when 'amount_of_tax_owed'
      LodgementFee.fee_level_3
    when 'late_return_or_payment'
      penalty_amount_tribunal_case_cost
    else
      raise "Unable to determine cost of income tax tribunal_case"
    end
  end

  def penalty_amount_tribunal_case_cost
    case tribunal_case.penalty_amount
    when '100_or_less'
      LodgementFee.fee_level_1
    when '101_to_20000'
      LodgementFee.fee_level_2
    else
      LodgementFee.fee_level_3
    end
  end
end
