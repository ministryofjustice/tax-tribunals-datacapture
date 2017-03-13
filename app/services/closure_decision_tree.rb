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
      show(:check_answers)
    when :check_answers
      home_path
    else
      raise "Invalid step '#{step_params}'"
    end
  end
end
