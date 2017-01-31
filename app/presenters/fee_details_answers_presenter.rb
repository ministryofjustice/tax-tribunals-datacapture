class FeeDetailsAnswersPresenter < BaseFeeAnswersPresenter
  def rows
    [
      challenged_decision_question,
      case_type_question,
      dispute_type_question,
      challenged_decision_status_question,
      penalty_level_question,
      penalty_amount_question,
      tax_amount_question,
      disputed_tax_paid_question,
      hardship_review_requested_question,
      hardship_review_status_question
    ].compact
  end
end
