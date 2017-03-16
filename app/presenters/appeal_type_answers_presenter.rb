class AppealTypeAnswersPresenter < BaseAnswersPresenter
  def rows
    [
      case_type_question,
      challenged_decision_question,
      challenged_decision_status_question,
      dispute_type_question,
      penalty_level_question,
      penalty_amount_question,
      tax_amount_question
    ].compact
  end

  def challenged_decision_question
    row(
      tribunal_case.challenged_decision,
      as: :challenged_decision
    )
  end

  def challenged_decision_status_question
    row(
      tribunal_case.challenged_decision_status,
      as: :challenged_decision_status
    )
  end

  def case_type_question
    return case_type_other_value_question if tribunal_case.case_type == CaseType::OTHER

    row(
      tribunal_case.case_type,
      as: :case_type,
      change_path: edit_steps_appeal_case_type_path
    )
  end

  def case_type_other_value_question
    row(
      tribunal_case.case_type_other_value,
      as: :case_type,
      i18n_value: false,
      change_path: edit_steps_appeal_case_type_path
    )
  end

  def dispute_type_question
    return dispute_type_other_value_question if tribunal_case.dispute_type == DisputeType::OTHER

    row(
      tribunal_case.dispute_type,
      as: :dispute_type
    )
  end

  def dispute_type_other_value_question
    row(
      tribunal_case.dispute_type_other_value,
      as: :dispute_type,
      i18n_value: false
    )
  end

  def penalty_level_question
    row(
      tribunal_case.penalty_level,
      as: :penalty_level
    )
  end

  def penalty_amount_question
    row(
      tribunal_case.penalty_amount,
      as: :penalty_amount,
      i18n_value: false
    )
  end

  def tax_amount_question
    row(
      tribunal_case.tax_amount,
      as: :tax_amount,
      i18n_value: false
    )
  end
end
