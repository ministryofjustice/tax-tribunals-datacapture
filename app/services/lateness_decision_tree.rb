class LatenessDecisionTree < DecisionTree
  def destination
    return @next_step if @next_step

    case step.to_sym
    when :in_time
      after_in_time_step
    when :lateness_reason
      after_lateness_reason_step
    else
      raise "Invalid step '#{step}'"
    end
  end

  def previous
    case step.to_sym
    when :in_time
      before_in_time_step
    when :lateness_reason
      before_lateness_reason_step
    else
      raise "Invalid step '#{step}'"
    end
  end

  private

  def before_in_time_step
    { controller: :start, action: :show }
  end

  def after_in_time_step
    case answer
    when :yes
      { controller: '/home', action: :index }
    when :no, :unsure
      { controller: :lateness_reason, action: :edit }
    end
  end

  def before_lateness_reason_step
    { controller: :in_time, action: :edit }
  end

  def after_lateness_reason_step
    { controller: '/home', action: :index }
  end
end
