class ChangeCostAnswersPresenter
  ChangeCostAnswerRow = Struct.new(:question, :answer, :change_path)

  include Rails.application.routes.url_helpers

  def initialize(tribunal_case)
    @tribunal_case = tribunal_case
  end

  attr_reader :tribunal_case

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
      as:   :challenged_decision,
      path: edit_steps_cost_challenged_decision_path
    )
  end

  def case_type_question
    path = if tribunal_case.challenged_decision
             edit_steps_cost_case_type_challenged_path
           else
             edit_steps_cost_case_type_unchallenged_path
           end

    row(
      tribunal_case.case_type,
      as:   :case_type,
      path: path
    )
  end

  def dispute_type_question
    row(
      tribunal_case.dispute_type,
      as:   :dispute_type,
      path: edit_steps_cost_dispute_type_path
    )
  end

  def penalty_amount_question
    row(
      tribunal_case.penalty_amount,
      as:   :penalty_amount,
      path: edit_steps_cost_penalty_amount_path
    )
  end

  def row(model_attribute, as:, path:)
    # `false` counts as blank, but is a valid value here so we can't use #blank?
    return if model_attribute.nil? || model_attribute == ''

    ChangeCostAnswerRow.new(
      ".questions.#{as}",
      ".answers.#{as}.#{model_attribute}",
      path
    )
  end
end
