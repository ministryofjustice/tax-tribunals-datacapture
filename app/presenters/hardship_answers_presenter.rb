class HardshipAnswersPresenter < BaseAnswersPresenter
  def rows
    [
      disputed_tax_paid_question,
      hardship_review_requested_question,
      hardship_review_status_question
    ].compact
  end

  def show_reason?
    tribunal_case.hardship_review_status == HardshipReviewStatus::REFUSED
  end

  private

  def disputed_tax_paid_question
    row(
      tribunal_case.disputed_tax_paid,
      as: :disputed_tax_paid
    )
  end

  def hardship_review_requested_question
    row(
      tribunal_case.hardship_review_requested,
      as: :hardship_review_requested
    )
  end

  def hardship_review_status_question
    row(
      tribunal_case.hardship_review_status,
      as: :hardship_review_status
    )
  end
end
