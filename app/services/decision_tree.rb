class DecisionTree
  include ApplicationHelper

  def initialize(object:, step:, next_step: nil)
    @object    = object
    @step      = step
    @next_step = next_step
  end

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
    when :what_is_late_penalty_or_surcharge
      after_what_is_late_penalty_or_surcharge_step
    else
      raise "Invalid step '#{step}'"
    end
  end

  private

  def after_challenged_decision_step
    case answer
    when :yes
      { controller: :case_type_challenged, action: :edit }
    when :no
      { controller: :case_type_unchallenged, action: :edit }
    end
  end

  def after_case_type_challenged_step
    case answer
    when :income_tax, :vat
      { controller: :dispute_type, action: :edit }
    else
      { controller: :determine_cost, action: :show }
    end
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

  def after_dispute_type_step
    case answer
    when :late_return_or_payment
      { controller: :what_is_late_penalty_or_surcharge, action: :edit }
    when :amount_of_tax_owed, :paye_coding_notice
      { controller: :determine_cost, action: :show }
    end
  end

  def after_what_is_late_penalty_or_surcharge_step
    { controller: :determine_cost, action: :show }
  end

  def step
    @step.keys.first
  end

  def answer
    @step.values.first.to_sym
  end
end
