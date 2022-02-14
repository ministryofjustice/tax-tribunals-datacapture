class TaxTribs::ClosureDecisionTree < TaxTribs::DecisionTree
  def destination
    return next_step if next_step

    case step_name.to_sym
    when :case_type
      case_type_or_save_step
    when :save_and_return
      edit(:select_language)
    when :language
      edit('/steps/details/user_type')
    when :enquiry_details
      edit(:additional_info)
    when :additional_info
      edit(:eu_exit)
    when :eu_exit
      edit(:need_support)
    when :need_support
      after_need_support_step
    when :what_support
      edit(:support_documents)
    when :support_documents
      show(:check_answers)
    when :check_answers
      root_path
    else
      raise InvalidStep, "Invalid step '#{step_params}'"
    end
  end

  private

  def case_type_or_save_step
    if tribunal_case.user_id.blank?
      @next_step = select_language_path
      edit('/steps/save_and_return')
    else
      edit('/steps/details/user_type')
    end
  end

  def after_need_support_step
    case tribunal_case.need_support
    when 'yes'
      edit(:what_support)
    when 'no'
      edit(:support_documents)
    end
  end

end
