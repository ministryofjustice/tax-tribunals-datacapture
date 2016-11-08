class WhatIsDisputeAboutForm < BaseForm
  attribute :what_is_dispute_about, String

  validates_inclusion_of :what_is_dispute_about, in: proc { |record| record.choices }

  def choices
    if include_paye_coding_notice?
      %w(
        late_return_or_payment
        amount_of_tax_owed
        paye_coding_notice
      )
    else
      %w(
        late_return_or_payment
        amount_of_tax_owed
      )
    end
  end

  private

  def include_paye_coding_notice?
    tribunal_case&.case_type&.income_tax?
  end

  def changed?
    tribunal_case.what_is_dispute_about != what_is_dispute_about
  end

  def persist!
    raise 'No TribunalCase given' unless tribunal_case
    return unless changed?

    tribunal_case.update(
      what_is_dispute_about: what_is_dispute_about,
      # The following are dependent attributes that need to be reset
      what_is_penalty_or_surcharge_amount: nil
    )
  end
end
