class DetailsDecisionTree < DecisionTree
  def destination
    return @next_step if @next_step

    case step.to_sym
    when :taxpayer_type
      after_taxpayer_type_step
    when :individual_details
      after_individual_details_step
    when :company_details
      after_company_details_step
    else
      raise "Invalid step '#{step}'"
    end
  end

  def previous
    case step.to_sym
    when :taxpayer_type
      before_taxpayer_type_step
    when :individual_details
      before_individual_details_step
    when :company_details
      before_company_details_step
    else
      raise "Invalid step '#{step}'"
    end
  end

  private

  def before_taxpayer_type_step
    { controller: :start, action: :show }
  end

  def after_taxpayer_type_step
    case answer
    when :individual
      { controller: :individual_details, action: :edit }
    when :company
      { controller: :company_details, action: :edit }
    end
  end

  def before_individual_details_step
    { controller: :taxpayer_type, action: :edit }
  end

  def after_individual_details_step
    { controller: '/home', action: :index }
  end

  def before_company_details_step
    { controller: :taxpayer_type, action: :edit }
  end

  def after_company_details_step
    { controller: '/home', action: :index }
  end
end
