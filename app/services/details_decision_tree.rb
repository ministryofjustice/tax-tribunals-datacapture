class DetailsDecisionTree < DecisionTree
  def destination
    return @next_step if @next_step

    case step.to_sym
    when :taxpayer_type
      after_taxpayer_type_step
    else
      raise "Invalid step '#{step}'"
    end
  end

  private

  def after_taxpayer_type_step
    { controller: '/home', action: :index }
  end
end
