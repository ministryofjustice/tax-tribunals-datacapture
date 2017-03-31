class ChallengeDecisionTree < DecisionTree
  def destination
    return next_step if next_step

    case step_name.to_sym
    when :challenged_decision
      after_decision_step
    when :challenged_decision_status
      after_decision_status_step
    else
      raise "Invalid step '#{step_params}'"
    end
  end

  private

  def direct_tax?
    tribunal_case.case_type.direct_tax?
  end

  def tribunal_case_is_challenged?
    tribunal_case.challenged_decision == ChallengedDecision::YES
  end

  def pending_challenge_direct_tax?
    tribunal_case.challenged_decision_status.pending? && direct_tax?
  end

  def pending_challenge_indirect_tax?
    tribunal_case.challenged_decision_status.pending? && !direct_tax?
  end

  def restoration_case?
    tribunal_case.case_type == CaseType::RESTORATION_CASE
  end

  def after_decision_step
    if tribunal_case_is_challenged?
      edit(:decision_status)
    elsif direct_tax?
      show(:must_challenge_hmrc)
    elsif restoration_case?
      show(:must_ask_for_review)
    else
      dispute_or_penalties_decision
    end
  end

  def after_decision_status_step
    if pending_challenge_direct_tax?
      show(:must_wait_for_challenge_decision)
    elsif pending_challenge_indirect_tax?
      show(:must_wait_for_review_decision)
    else
      dispute_or_penalties_decision
    end
  end
end
