class ClosureDecisionTree < DecisionTree
  def destination
    return next_step if next_step

    case step_name.to_sym
    when :case_type
      edit('/steps/details/user_type')
    when :enquiry_details
      edit(:additional_info)
    when :additional_info
      edit(:support_documents)
    when :support_documents
      after_support_documents
    when :check_answers
      home_path
    else
      raise "Invalid step '#{step_params}'"
    end
  end

  private

  def after_support_documents
    if tribunal_case.having_problems_uploading_documents?
      show(:documents_upload_problems)
    else
      show(:check_answers)
    end
  end
end
