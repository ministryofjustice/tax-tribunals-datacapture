class ChangeCostAnswersPresenter < BaseAnswersPresenter
  def rows
    [
      challenged_decision_question,
      case_type_question,
      dispute_type_question,
      penalty_amount_question
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

  def penalty_amount_question
    row(
      tribunal_case.penalty_amount,
      as: :penalty_amount,
      change_path: edit_steps_cost_penalty_amount_path
    )
  end
end
