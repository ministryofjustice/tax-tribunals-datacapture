class AppealDecisionTree < DecisionTree
  def destination
    return next_step if next_step

    case step_name.to_sym
    when :case_type, :case_type_show_more
      after_case_type_step
    when :challenged_decision
      after_challenged_decision_step
    when :challenged_decision_status
      after_challenged_decision_status_step
    when :dispute_type
      after_dispute_type_step
    when :penalty_amount, :penalty_and_tax_amounts, :tax_amount
      hardship_or_lateness_step
    else
      raise "Invalid step '#{step_params}'"
    end
  end

  private

  def direct_tax?
    tribunal_case.case_type.direct_tax?
  end

  # TODO: most of the following methods will be moved to ChallengeDecisionTree, de-cluttering this class
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

  # TODO: challenge decisions and journeys to be moved to their own decision tree
  def after_case_type_step
    if answer == Steps::Appeal::CaseTypeForm::SHOW_MORE
      edit(:case_type_show_more)
    elsif tribunal_case.case_type.ask_challenged?
      edit(:challenged_decision)
    else
      dispute_or_penalties_decision
    end
  end

  # TODO: challenge decisions and journeys to be moved to their own decision tree
  def after_challenged_decision_step
    if tribunal_case_is_challenged?
      edit(:challenged_decision_status)
    elsif direct_tax?
      show(:must_challenge_hmrc)
    elsif restoration_case?
      show('/steps/challenge/must_ask_for_review')
    else
      dispute_or_penalties_decision
    end
  end

  # TODO: challenge decisions and journeys to be moved to their own decision tree
  def after_challenged_decision_status_step
    if pending_challenge_direct_tax?
      show(:must_wait_for_challenge_decision)
    elsif pending_challenge_indirect_tax?
      show('/steps/challenge/must_wait_for_review_decision')
    else
      dispute_or_penalties_decision
    end
  end

  def after_dispute_type_step
    if tribunal_case.dispute_type.ask_penalty?
      edit(:penalty_amount)
    elsif tribunal_case.dispute_type.ask_tax?
      edit(:tax_amount)
    elsif tribunal_case.dispute_type.ask_penalty_and_tax?
      edit(:penalty_and_tax_amounts)
    else
      hardship_or_lateness_step
    end
  end

  def hardship_or_lateness_step
    if tribunal_case.case_type.ask_hardship? && tribunal_case.dispute_type.ask_hardship?
      edit('/steps/hardship/disputed_tax_paid')
    else
      edit('steps/lateness/in_time')
    end
  end

  def dispute_or_penalties_decision
    if tribunal_case.case_type.ask_dispute_type?
      edit(:dispute_type)
    elsif tribunal_case.case_type.ask_penalty?
      edit(:penalty_amount)
    else
      edit('/steps/lateness/in_time')
    end
  end
end
