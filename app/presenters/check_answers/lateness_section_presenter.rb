module CheckAnswers
  class LatenessSectionPresenter < SectionPresenter
    def name
      :lateness
    end

    def answers
      [
        Answer.new(:in_time, tribunal_case.in_time, change_path: edit_steps_lateness_in_time_path),
        FileOrTextAnswer.new(:lateness_reason, tribunal_case.lateness_reason, tribunal_case.documents(:lateness_reason).first,
                             change_path: edit_steps_lateness_lateness_reason_path)
      ].select(&:show?)
    end
  end
end
