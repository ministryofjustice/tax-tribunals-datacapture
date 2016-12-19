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

  def after_case_type_step
    case answer
    when :income_tax
      if tribunal_case.challenged_decision == ChallengedDecision::YES
        edit(:dispute_type)
      elsif tribunal_case.challenged_decision == ChallengedDecision::NO
        show(:must_challenge_hmrc)
      end
    when :air_passenger_duty, :bingo_duty, :vat
      edit(:dispute_type)
    when :inaccurate_return_penalty
      edit(:penalty_amount)
    when :other
      show(:determine_cost)
    when Steps::Cost::CaseTypeForm::SHOW_MORE
      edit(:case_type_show_more)
    end
  end

  def after_dispute_type_step
    case answer
    when :penalty
      edit(:penalty_amount)
    when :amount_of_tax, :amount_and_penalty, :decision_on_enquiry, :paye_coding_notice, :other
      show(:determine_cost)
    end
  end
end
