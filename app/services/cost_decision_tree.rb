class CostDecisionTree < DecisionTree
  def destination
    return @next_step if @next_step

    case step.to_sym
    when :challenged_decision
      after_challenged_decision_step
    when :case_type_challenged
      after_case_type_challenged_step
    when :case_type_unchallenged
      after_case_type_unchallenged_step
    when :dispute_type
      after_dispute_type_step
    when :penalty_amount
      after_penalty_amount_step
    else
      raise "Invalid step '#{step}'"
    end
  end

  def previous
    case step.to_sym
    when :challenged_decision
      before_challenged_decision_step
    when :case_type_challenged
      before_case_type_challenged_step
    when :case_type_unchallenged
      before_case_type_unchallenged_step
    when :dispute_type
      before_dispute_type_step
    when :penalty_amount
      before_penalty_amount_step
    else
      raise "Invalid step '#{step}'"
    end
  end

  private

  def before_challenged_decision_step
    { controller: :start, action: :show }
  end

  def after_challenged_decision_step
    case answer
    when :yes
      { controller: :case_type_challenged, action: :edit }
    when :no
      { controller: :case_type_unchallenged, action: :edit }
    end
  end

  def before_case_type_challenged_step
    { controller: :challenged_decision, action: :edit }
  end

  def after_case_type_challenged_step
    case answer
    when :income_tax, :vat
      { controller: :dispute_type, action: :edit }
    else
      { controller: :determine_cost, action: :show }
    end
  end

  def before_case_type_unchallenged_step
    { controller: :challenged_decision, action: :edit }
  end

  def after_case_type_unchallenged_step
    case answer
    when :income_tax
      { controller: :must_challenge_hmrc, action: :show }
    when :vat
      { controller: :dispute_type, action: :edit }
    else
      { controller: :determine_cost, action: :show }
    end
  end

  def before_dispute_type_step
    if @object.challenged_decision
      { controller: :case_type_challenged, action: :edit }
    else
      { controller: :case_type_unchallenged, action: :edit }
    end
  end

  def after_dispute_type_step
    case answer
    when :late_return_or_payment
      { controller: :penalty_amount, action: :edit }
    when :amount_of_tax_owed, :paye_coding_notice
      { controller: :determine_cost, action: :show }
    end
  end

  def before_penalty_amount_step
    { controller: :dispute_type, action: :edit }
  end

  def after_penalty_amount_step
    { controller: :determine_cost, action: :show }
  end
end
