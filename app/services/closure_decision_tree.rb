class ClosureDecisionTree < DecisionTree
  def destination
    return next_step if next_step

    case step_name.to_sym
    when :case_type
      edit('/steps/details/taxpayer_type')
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
    else
      raise "Invalid step '#{step_params}'"
    end
  end
end
