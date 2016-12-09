class LatenessDecisionTree < DecisionTree
  def destination
    return next_step if next_step

    case step_name.to_sym
    when :in_time
      after_in_time_step
    when :lateness_reason
      home
    else
      raise "Invalid step '#{step_params}'"
    end
  end

  def previous
    case step_name.to_sym
    when :in_time
      show(:start)
    when :lateness_reason
      edit(:in_time)
    else
      raise "Invalid step '#{step_params}'"
    end
  end

  private

  def after_in_time_step
    case answer
    when :yes
      home
    when :no, :unsure
      edit(:lateness_reason)
    end
  end
end
