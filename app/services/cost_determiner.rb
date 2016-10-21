# Given an appeal object, figure out the cost to the appellant of lodging the appeal,
# and any likely further costs (such as determination fee)
class CostDeterminer
  attr_reader :appeal

  def initialize(appeal)
    @appeal = appeal
  end

  def run
    raise InvalidAppealError unless appeal.valid_for_costing?

    case appeal.appeal_about
    when :income_tax
      income_tax_appeal_cost
    when :vat
      vat_appeal_cost
    when :apn_penalty, :closure_notice, :information_notice, :request_permission_for_review, :other
      AppealCost.medium
    when :inaccurate_return
      inaccurate_return_cost
    else
      raise "Unable to determine cost of appeal"
    end
  end

  private

  def vat_appeal_cost
    case appeal.dispute_about
    when :amount_of_tax_owed
      AppealCost.large
    when :late_return_or_payment
      penalty_amount_appeal_cost
    else
      raise "Unable to determine cost of VAT appeal"
    end
  end

  def income_tax_appeal_cost
    case appeal.dispute_about
    when :paye_coding_notice
      AppealCost.medium
    when :amount_of_tax_owed
      AppealCost.large
    when :late_return_or_payment
      penalty_amount_appeal_cost
    else
      raise "Unable to determine cost of income tax appeal"
    end
  end

  def penalty_amount_appeal_cost
    case appeal.penalty_or_surcharge_amount
    when 0..10000
      AppealCost.small
    when 10001..2000000
      AppealCost.medium
    else
      AppealCost.large
    end
  end

  def inaccurate_return_cost
    case appeal.inaccurate_return_type
    when :careless
      AppealCost.medium
    when :deliberate
      AppealCost.large
    else
      raise "Unable to determine cost of inaccurate return appeal"
    end
  end
end
