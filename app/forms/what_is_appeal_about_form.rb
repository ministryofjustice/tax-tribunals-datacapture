class WhatIsAppealAboutForm < BaseForm
  attribute :what_is_appeal_about, String

  def self.choices
    TribunalCase.what_is_appeal_about_values
  end

  validates_inclusion_of :what_is_appeal_about, in: choices

  private

  def persist!
    raise 'No TribunalCase given' unless tribunal_case
    tribunal_case.update(what_is_appeal_about: what_is_appeal_about)
  end
end
