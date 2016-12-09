class CostDecisionTree < DecisionTree
  def destination
    return next_step if next_step

    case step_name.to_sym
    when :challenged_decision
      edit(:case_type)
    when :case_type
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
      if tribunal_case.challenged_decision
        edit(:dispute_type)
      else
        show(:must_challenge_hmrc)
      end
    when :vat
      edit(:dispute_type)
    else
      show(:determine_cost)
    end
  end

  def after_dispute_type_step
    case answer
    when :late_return_or_payment
      edit(:penalty_amount)
    when :amount_of_tax_owed, :paye_coding_notice
      show(:determine_cost)
    end
  end
end
