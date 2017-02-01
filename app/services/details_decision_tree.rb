class DetailsDecisionTree < DecisionTree
  def destination
    return next_step if next_step

    case step_name.to_sym
    when :taxpayer_type
      edit(:taxpayer_details)
    when :taxpayer_details
      edit(:has_representative)
    when :has_representative
      after_has_representative_step
    when :representative_type
      edit(:representative_details)
    when :representative_details
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
    when :taxpayer_details
      edit(:taxpayer_type)
    when :has_representative
      edit(:taxpayer_details)
    when :representative_type
      edit(:has_representative)
    when :representative_details
      edit(:representative_type)
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

  def before_taxpayer_type_step
    case tribunal_case.intent
    when Intent::TAX_APPEAL
      show(:start)
    when Intent::CLOSE_ENQUIRY
      edit('/steps/closure/case_type')
    end
  end

  def after_has_representative_step
    case tribunal_case.has_representative
    when HasRepresentative::YES
      edit(:representative_type)
    when HasRepresentative::NO
      after_details_step
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

  def before_grounds_for_appeal_step
    case tribunal_case.has_representative
    when HasRepresentative::YES
      edit(:representative_details)
    when HasRepresentative::NO
      edit(:has_representative)
    end
  end
end
