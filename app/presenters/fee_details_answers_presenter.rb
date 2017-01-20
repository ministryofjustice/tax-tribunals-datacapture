class FeeDetailsAnswersPresenter < BaseAnswersPresenter
  include ActionView::Helpers::NumberHelper

  def rows
    [
      challenged_decision_question,
      case_type_question,
      dispute_type_question,
      penalty_level_question,
      penalty_amount_question,
      tax_amount_question,
      fee_amount_question
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
      as: :dispute_type
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

  def fee_amount_question
    row(
      number_to_currency(tribunal_case.lodgement_fee / 100.0),
      as: :fee_amount,
      i18n_value: false
    ) if tribunal_case.lodgement_fee.present?
  end
end
