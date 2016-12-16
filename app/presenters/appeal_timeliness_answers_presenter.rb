class AppealTimelinessAnswersPresenter < BaseAnswersPresenter
  def rows
    [
      in_time_question,
      lateness_reason_question
    ].compact
  end

  private

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
      i18n_value: false
    )
  end
end
