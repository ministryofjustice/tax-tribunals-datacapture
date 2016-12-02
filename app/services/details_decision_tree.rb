class DetailsDecisionTree < DecisionTree
  def destination
    return @next_step if @next_step

    case step.to_sym
    when :taxpayer_type
      after_taxpayer_type_step
    when :individual_details, :company_details
      edit(:grounds_for_appeal)
    when :grounds_for_appeal
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
    when :grounds_for_appeal
      before_grounds_for_appeal_step
    else
      raise "Invalid step '#{step}'"
    end
  end

  private

  def before_grounds_for_appeal_step
    case @object.taxpayer_type
    when TaxpayerType::INDIVIDUAL
      edit(:individual_details)
    when TaxpayerType::COMPANY
      edit(:company_details)
    end
  end

  def after_taxpayer_type_step
    case answer
    when :individual
      edit(:individual_details)
    when :company
      edit(:company_details)
    end
  end
end
