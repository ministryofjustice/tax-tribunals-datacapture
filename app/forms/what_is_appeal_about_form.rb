class WhatIsAppealAboutForm < BaseForm
  attribute :what_is_appeal_about, String

  def self.choices
    TribunalCase.what_is_appeal_about_values
  end

  validates_inclusion_of :what_is_appeal_about, in: choices

  private

  def changed?
    tribunal_case.what_is_appeal_about != what_is_appeal_about
  end

  def persist!
    raise 'No TribunalCase given' unless tribunal_case
    return unless changed?

    tribunal_case.update(
      what_is_appeal_about: what_is_appeal_about,
      # The following are dependent attributes that need to be reset
      what_is_dispute_about: nil,
      what_is_penalty_or_surcharge_amount: nil
    )
  end
end
