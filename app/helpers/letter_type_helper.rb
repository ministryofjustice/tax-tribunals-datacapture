module LetterTypeHelper
  def i18n_letter_type
    case current_tribunal_case.challenged_decision_status
    when ChallengedDecisionStatus::RECEIVED
      :review_conclusion_letter
    when ChallengedDecisionStatus::APPEAL_LATE_REJECTION
      :late_appeal_refusal_letter
    when ChallengedDecisionStatus::REVIEW_LATE_REJECTION
      :late_review_refusal_letter
    else
      :original_notice_letter
    end
  end
end
