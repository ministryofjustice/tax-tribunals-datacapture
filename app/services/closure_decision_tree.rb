class ClosureDecisionTree < DecisionTree
  def destination
    return next_step if next_step

    case step_name.to_sym
    when :case_type
      edit('/steps/details/taxpayer_type')
    when :enquiry_details
      edit(:additional_info)
    when :additional_info
      edit(:support_documents)
    when :support_documents
      show(:start) # TODO: check your answers step
    else
      raise "Invalid step '#{step_params}'"
    end
  end

  def previous
    case step_name.to_sym
    when :case_type
      show(:start)
    when :enquiry_details
      edit('/steps/details/taxpayer_type')
    when :additional_info
      edit(:enquiry_details)
    when :support_documents
      edit(:additional_info)
    else
      raise "Invalid step '#{step_params}'"
    end
  end
end
