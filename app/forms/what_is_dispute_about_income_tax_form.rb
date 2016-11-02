class WhatIsDisputeAboutIncomeTaxForm < BaseForm
  attribute :what_is_dispute_about, String

  def self.choices
    %w(
      late_return_or_payment
      amount_of_tax_owed
      paye_coding_notice
    )
  end
  validates_inclusion_of :what_is_dispute_about, in: choices

  private

  def persist!
    raise 'No TribunalCase given' unless tribunal_case
    tribunal_case.update(
      what_is_dispute_about: what_is_dispute_about,
      # The following are dependent attributes that need to be reset
      what_is_penalty_or_surcharge_amount: nil
    )
  end
end
