class AppealLatenessAnswersPresenter < BaseAnswersPresenter
  def rows
    [
      in_time_question,
      lateness_reason_question
    ].compact
  end

  def in_time_question
    row(
      tribunal_case.in_time,
      as: :in_time,
      change_path: edit_steps_lateness_in_time_path
    )
  end

  def lateness_reason_question
    row(
      tribunal_case.lateness_reason,
      as: :lateness_reason,
      i18n_value: false,
      change_path: edit_steps_lateness_lateness_reason_path
    )
  end
end
