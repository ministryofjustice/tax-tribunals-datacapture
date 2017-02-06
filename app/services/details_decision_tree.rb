class DetailsDecisionTree < DecisionTree
  def destination
    return next_step if next_step

    case step_name.to_sym
    when :user_type
      after_user_type_step
    when :taxpayer_type
      edit(:taxpayer_details)
    when :taxpayer_details
      after_taxpayer_details_step
    when :has_representative
      after_has_representative_step
    when :representative_type
      edit(:representative_details)
    when :representative_details
      after_representative_details_step
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
    when :user_type
      before_user_type_step
    when :taxpayer_type
      before_taxpayer_type_step
    when :taxpayer_details
      edit(:taxpayer_type)
    when :has_representative
      edit(:taxpayer_details)
    when :representative_type
      before_representative_type_step
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

  def after_user_type_step
    case tribunal_case.user_type
    when UserType::TAXPAYER
      edit(:taxpayer_type)
    when UserType::REPRESENTATIVE
      edit(:representative_type)
    end
  end

  def before_user_type_step
    case tribunal_case.intent
    when Intent::TAX_APPEAL
      show(:start)
    when Intent::CLOSE_ENQUIRY
      edit('/steps/closure/case_type')
    end
  end

  def before_taxpayer_type_step
    case tribunal_case.user_type
    when UserType::TAXPAYER
      edit(:user_type)
    when UserType::REPRESENTATIVE
      edit(:representative_details)
    end
  end

  def after_taxpayer_details_step
    case tribunal_case.user_type
    when UserType::TAXPAYER
      edit(:has_representative)
    when UserType::REPRESENTATIVE
      after_details_step
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

  def before_representative_type_step
    case tribunal_case.user_type
    when UserType::TAXPAYER
      edit(:has_representative)
    when UserType::REPRESENTATIVE
      edit(:user_type)
    end
  end

  def after_representative_details_step
    case tribunal_case.user_type
    when UserType::TAXPAYER
      after_details_step
    when UserType::REPRESENTATIVE
      edit(:taxpayer_type)
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
      if tribunal_case.user_type == UserType::TAXPAYER
        edit(:representative_details)
      elsif tribunal_case.user_type == UserType::REPRESENTATIVE
        edit(:taxpayer_details)
      end
    when HasRepresentative::NO
      edit(:has_representative)
    end
  end
end
