class DetailsDecisionTree < DecisionTree
  def destination
    return @next_step if @next_step

    case step.to_sym
    when :taxpayer_type
      after_taxpayer_type_step
    when :individual_details, :company_details
      home
    else
      raise "Invalid step '#{step}'"
    end
  end

  def previous
    case step.to_sym
    when :taxpayer_type
      show(:start)
    when :individual_details, :company_details
      edit(:taxpayer_type)
    else
      raise "Invalid step '#{step}'"
    end
  end

  private

  def after_taxpayer_type_step
    case answer
    when :individual
      edit(:individual_details)
    when :company
      edit(:company_details)
    end
  end
end
