class ChallengedDecisionForm < BaseForm
  attribute :challenged_decision, Boolean

  validates_inclusion_of :challenged_decision, in: [true, false]

  private

  def changed?
    tribunal_case.challenged_decision != challenged_decision
  end

  def persist!
    raise 'No TribunalCase given' unless tribunal_case
    return unless changed?

    tribunal_case.update(
      challenged_decision: challenged_decision,
      # The following are dependent attributes that need to be reset
      case_type: nil,
      dispute_type: nil,
      what_is_penalty_or_surcharge_amount: nil
    )
  end
end
