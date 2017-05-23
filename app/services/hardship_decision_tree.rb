class HardshipDecisionTree < TaxTribs::DecisionTree
  def destination
    return next_step if next_step

    case step_name.to_sym
    when :disputed_tax_paid
      after_disputed_tax_paid_step
    when :hardship_review_requested
      after_hardship_review_requested_step
    when :hardship_review_status
      after_hardship_review_status
    when :hardship_reason
      { controller: '/steps/lateness/in_time', action: :edit }
    else
      raise "Invalid step '#{step_params}'"
    end
  end

  private

  def after_disputed_tax_paid_step
    case tribunal_case.disputed_tax_paid
    when DisputedTaxPaid::YES
      { controller: '/steps/lateness/in_time', action: :edit }
    when DisputedTaxPaid::NO
      { controller: :hardship_review_requested, action: :edit }
    end
  end

  def after_hardship_review_requested_step
    case tribunal_case.hardship_review_requested
    when HardshipReviewRequested::YES
      { controller: :hardship_review_status, action: :edit }
    when HardshipReviewRequested::NO
      { controller: '/steps/lateness/in_time', action: :edit }
    end
  end

  def after_hardship_review_status
    case tribunal_case.hardship_review_status
    when HardshipReviewStatus::GRANTED
      { controller: '/steps/lateness/in_time', action: :edit }
    when HardshipReviewStatus::PENDING
      { controller: '/steps/lateness/in_time', action: :edit }
    when HardshipReviewStatus::REFUSED
      { controller: :hardship_reason, action: :edit }
    end
  end
end
