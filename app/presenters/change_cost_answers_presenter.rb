class ChangeCostAnswersPresenter < BaseAnswersPresenter
  def rows
    [
      challenged_decision_question,
      case_type_question,
      challenged_decision_status_question,
      dispute_type_question,
      tax_amount_question,
      penalty_level_question,
      penalty_amount_question,
      disputed_tax_paid_question,
      hardship_review_requested_question,
      hardship_review_status_question
    ].compact
  end

  private

  def challenged_decision_question
    row(
      tribunal_case.challenged_decision,
      as: :challenged_decision,
      change_path: edit_steps_cost_challenged_decision_path
    )
  end

  def challenged_decision_status_question
    row(
      tribunal_case.challenged_decision_status,
      as: :challenged_decision_status,
      change_path: edit_steps_cost_challenged_decision_status_path
    )
  end

  def case_type_question
    row(
      tribunal_case.case_type,
      as: :case_type,
      change_path: edit_steps_cost_case_type_path
    )
  end

  def dispute_type_question
    row(
      tribunal_case.dispute_type,
      as: :dispute_type,
      change_path: edit_steps_cost_dispute_type_path
    )
  end

  def penalty_level_question
    row(
      tribunal_case.penalty_level,
      as: :penalty_level,
      change_path: edit_steps_cost_penalty_amount_path
    )
  end

  def penalty_amount_question
    row(
      tribunal_case.penalty_amount,
      as: :penalty_amount,
      i18n_value: false,
      change_path: edit_steps_cost_penalty_amount_path
    )
  end

  def tax_amount_question
    row(
      tribunal_case.tax_amount,
      as: :tax_amount,
      i18n_value: false,
      change_path: edit_steps_cost_tax_amount_path
    )
  end

  def disputed_tax_paid_question
    row(
      tribunal_case.disputed_tax_paid,
      as: :disputed_tax_paid,
      change_path: edit_steps_hardship_disputed_tax_paid_path
    )
  end

  def hardship_review_requested_question
    row(
      tribunal_case.hardship_review_requested,
      as: :hardship_review_requested,
      change_path: edit_steps_hardship_hardship_review_requested_path
    )
  end

  def hardship_review_status_question
    row(
      tribunal_case.hardship_review_status,
      as: :hardship_review_status,
      change_path: edit_steps_hardship_hardship_review_status_path
    )
  end
end
