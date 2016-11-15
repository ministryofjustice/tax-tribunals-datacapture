class PenaltyAmountForm < BaseForm
  attribute :penalty_amount, String

  def self.choices
    PenaltyAmount.values.map(&:to_s)
  end
  validates_inclusion_of :penalty_amount, in: choices

  private

  def penalty_amount_value
    PenaltyAmount.new(penalty_amount)
  end

  def persist!
    raise 'No TribunalCase given' unless tribunal_case
    tribunal_case.update(penalty_amount: penalty_amount_value)
  end
end
