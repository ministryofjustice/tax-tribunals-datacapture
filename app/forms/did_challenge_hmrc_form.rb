class DidChallengeHmrcForm < BaseForm
  attribute :did_challenge_hmrc, Boolean

  validates_inclusion_of :did_challenge_hmrc, in: [true, false]

  private

  def persist!
    raise 'No TribunalCase given' unless tribunal_case
    tribunal_case.update(
      did_challenge_hmrc: did_challenge_hmrc,
      # The following are dependent attributes that need to be reset
      what_is_appeal_about: nil,
      what_is_dispute_about: nil,
      what_is_penalty_or_surcharge_amount: nil
    )
  end
end
