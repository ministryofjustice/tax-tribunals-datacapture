class ClosureDecisionTree < DecisionTree
  def destination
    return next_step if next_step

    case step_name.to_sym
    when :case_type
      # TODO: do something
    else
      raise "Invalid step '#{step_params}'"
    end
  end

  def previous
    case step_name.to_sym
    when :case_type
      show(:start)
    else
      raise "Invalid step '#{step_params}'"
    end
  end
end
