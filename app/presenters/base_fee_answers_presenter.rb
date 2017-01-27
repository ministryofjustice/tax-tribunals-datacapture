class BaseFeeAnswersPresenter < BaseAnswersPresenter
  include ActionView::Helpers::NumberHelper

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
    return case_type_other_value_question if tribunal_case.case_type == CaseType::OTHER

    row(
      tribunal_case.case_type,
      as: :case_type,
      change_path: edit_steps_cost_case_type_path
    )
  end

  def case_type_other_value_question
    row(
      tribunal_case.case_type_other_value,
      as: :case_type,
      i18n_value: false,
      change_path: edit_steps_cost_case_type_show_more_path
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

  def fee_amount_question
    row(
      number_to_currency(tribunal_case.lodgement_fee / 100.0),
      as: :fee_amount,
      i18n_value: false
    ) if tribunal_case.lodgement_fee.present?
  end
end
