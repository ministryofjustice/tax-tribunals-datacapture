class WhatIsLatePenaltyOrSurchargeForm < BaseForm
  attribute :what_is_penalty_or_surcharge_amount, String

  def self.choices
    %w(
      100_or_less
      101_to_20000
      20001_or_more
    )
  end
  validates_inclusion_of :what_is_penalty_or_surcharge_amount, in: choices

  private

  def persist!
    raise 'No TribunalCase given' unless tribunal_case
    tribunal_case.update(what_is_penalty_or_surcharge_amount: what_is_penalty_or_surcharge_amount)
  end
end
