class PenaltyAmountForm < BaseForm
  attribute :penalty_amount, String

  def self.choices
    %w(
      100_or_less
      101_to_20000
      20001_or_more
    )
  end
  validates_inclusion_of :penalty_amount, in: choices

  private

  def persist!
    raise 'No TribunalCase given' unless tribunal_case
    tribunal_case.update(penalty_amount: penalty_amount)
  end
end
