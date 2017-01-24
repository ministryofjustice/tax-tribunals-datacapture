class DetailsDecisionTree < DecisionTree
  def destination
    return next_step if next_step

    case step_name.to_sym
    when :taxpayer_type
      after_taxpayer_type_step
    when :individual_details, :company_details
      edit(:grounds_for_appeal)
    when :grounds_for_appeal
      edit(:outcome)
    when :outcome
      edit(:documents_checklist)
    when :documents_checklist
      show(:check_answers)
    when :check_answers
      task_list
    else
      raise "Invalid step '#{step_params}'"
    end
  end

  def previous
    case step_name.to_sym
    when :taxpayer_type
      show(:start)
    when :individual_details, :company_details
      edit(:taxpayer_type)
    when :grounds_for_appeal
      before_grounds_for_appeal_step
    when :outcome
      edit(:grounds_for_appeal)
    when :documents_checklist
      edit(:outcome)
    when :check_answers
      edit(:documents_checklist)
    else
      raise "Invalid step '#{step_params}'"
    end
  end

  private

  def before_grounds_for_appeal_step
    case tribunal_case.taxpayer_type
    when TaxpayerType::INDIVIDUAL
      edit(:individual_details)
    when TaxpayerType::COMPANY
      edit(:company_details)
    end
  end

  def after_taxpayer_type_step
    case answer
    when :individual
      edit(:individual_details)
    when :company
      edit(:company_details)
    end
  end
end
