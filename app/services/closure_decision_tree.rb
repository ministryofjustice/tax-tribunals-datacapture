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
      before_enquiry_details_step
    when :additional_info
      edit(:enquiry_details)
    when :support_documents
      edit(:additional_info)
    else
      raise "Invalid step '#{step_params}'"
    end
  end

  private

  def before_enquiry_details_step
    case tribunal_case.user_type
    when UserType::REPRESENTATIVE
      edit('/steps/details/taxpayer_details')
    when UserType::TAXPAYER
      if tribunal_case.has_representative == HasRepresentative::YES
        edit('/steps/details/representative_details')
      else
        edit('/steps/details/has_representative')
      end
    end
  end
end
