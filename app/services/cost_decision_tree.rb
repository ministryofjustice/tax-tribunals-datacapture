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
    when :penalty_amount, :tax_amount, :penalty_and_tax_amounts
      hardship_or_determine_cost_step
    when :challenged_decision_status
      edit(:dispute_type)
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
    when :case_type_show_more, :challenged_decision_status
      edit(:case_type)
    when :dispute_type
      before_dispute_type_step
    when :penalty_amount, :tax_amount, :penalty_and_tax_amounts
      before_penalty_or_tax_amount_step
    else
      raise "Invalid step '#{step_params}'"
    end
  end

  private

  def tribunal_case_is_unchallenged_direct_tax
    tribunal_case.case_type.direct_tax? &&
      tribunal_case.challenged_decision == ChallengedDecision::NO
  end

  def tribunal_case_is_challenged_indirect_tax
    !tribunal_case.case_type.direct_tax? &&
      tribunal_case.challenged_decision == ChallengedDecision::YES
  end

  def after_case_type_step
    if answer == Steps::Cost::CaseTypeForm::SHOW_MORE
      edit(:case_type_show_more)
    elsif tribunal_case_is_unchallenged_direct_tax
      show(:must_challenge_hmrc)
    elsif tribunal_case_is_challenged_indirect_tax
      edit(:challenged_decision_status)
    elsif tribunal_case.case_type.ask_dispute_type?
      edit(:dispute_type)
    elsif tribunal_case.case_type.ask_penalty?
      edit(:penalty_amount)
    else
      show(:determine_cost)
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
      hardship_or_determine_cost_step
    end
  end

  def hardship_or_determine_cost_step
    if tribunal_case.case_type.ask_hardship? && tribunal_case.dispute_type.ask_hardship?
      edit('/steps/hardship/disputed_tax_paid')
    else
      show(:determine_cost)
    end
  end

  def before_dispute_type_step
    if Steps::Cost::CaseTypeForm.choices.include?(tribunal_case.case_type.to_s)
      edit(:case_type)
    else
      edit(:case_type_show_more)
    end
  end

  def before_penalty_or_tax_amount_step
    if tribunal_case.dispute_type?
      edit(:dispute_type)
    else
      before_dispute_type_step
    end
  end
end
