class DetailsDecisionTree < DecisionTree
  def destination
    return next_step if next_step

    case step_name.to_sym
    when :taxpayer_type
      after_taxpayer_type_step
    when :individual_details, :organisation_details
      after_details_step
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
      before_taxpayer_type_step
    when :individual_details, :organisation_details
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
    when ContactableEntityType::INDIVIDUAL
      edit(:individual_details)
    when ContactableEntityType::COMPANY
      edit(:organisation_details)
    end
  end

  def after_taxpayer_type_step
    case answer
    when :individual
      edit(:individual_details)
    when :organisation, :other_organisation
      edit(:organisation_details)
    end
  end

  def before_taxpayer_type_step
    case tribunal_case.intent
    when Intent::TAX_APPEAL
      show(:start)
    when Intent::CLOSE_ENQUIRY
      edit('/steps/closure/case_type')
    end
  end

  def after_details_step
    case tribunal_case.intent
    when Intent::TAX_APPEAL
      edit(:grounds_for_appeal)
    when Intent::CLOSE_ENQUIRY
      edit('/steps/closure/enquiry_details')
    end
  end
end
