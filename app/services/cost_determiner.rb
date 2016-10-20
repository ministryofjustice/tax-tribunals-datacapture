# Given an appeal object, figure out the cost to the appellant of lodging the appeal,
# and any likely further costs (such as determination fee)
class CostDeterminer
  attr_reader :appeal

  def initialize(appeal)
    @appeal = appeal
  end

  def run
    case appeal.appeal_about
    when :income_tax
      income_tax_appeal_cost
    when :apn_penalty, :closure_notice, :information_notice, :request_permission_for_review, :other
      AppealCost.new(lodgement_fee: 5000)
    else
      raise "Unable to determine cost of appeal"
    end
  end

  private

  def income_tax_appeal_cost
    case appeal.dispute_about
    when :paye_coding_notice
      AppealCost.new(lodgement_fee: 5000)
    when :amount_of_tax_owed
      AppealCost.new(lodgement_fee: 20000)
    else
      raise "Unable to determine cost of income tax appeal"
    end
  end
end
