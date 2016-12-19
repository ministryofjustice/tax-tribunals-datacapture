class CostDecisionTree < DecisionTree
  def destination
    return next_step if next_step

    case step_name.to_sym
    when :challenged_decision
      edit(:case_type)
    when :case_type, :case_type_show_more
      after_case_type_step
    when :dispute_type
      after_dispute_type_step
    when :penalty_amount
      show(:determine_cost)
    else
      raise "Invalid step '#{step_params}'"
    end
  end

  def previous
    case step_name.to_sym
    when :challenged_decision
      show(:start)
    when :case_type
      edit(:challenged_decision)
    when :case_type_show_more
      edit(:case_type)
    when :dispute_type
      edit(:case_type)
    when :penalty_amount
      edit(:dispute_type)
    else
      raise "Invalid step '#{step_params}'"
    end
  end

  private

  def tribunal_case_is_unchallenged_direct_tax
    tribunal_case.case_type.direct_tax? &&
      tribunal_case.challenged_decision == ChallengedDecision::NO
  end

  def after_case_type_step
    if answer == Steps::Cost::CaseTypeForm::SHOW_MORE
      edit(:case_type_show_more)
    elsif tribunal_case_is_unchallenged_direct_tax
      show(:must_challenge_hmrc)
    elsif tribunal_case.case_type.ask_dispute_type?
      edit(:dispute_type)
    elsif tribunal_case.case_type.ask_penalty?
      edit(:penalty_amount)
    else
      show(:determine_cost)
    end
  end

  def after_dispute_type_step
    if tribunal_case.dispute_type == DisputeType::PENALTY
      edit(:penalty_amount)
    else
      show(:determine_cost)
    end
  end
end
