module CheckAnswers
  class ClosureTypeSectionPresenter < SectionPresenter
    def name
      :closure_type
    end

    def answers
      [
        Answer.new(:closure_case_type, tribunal_case.closure_case_type, change_path: edit_steps_closure_case_type_path)
      ].select(&:show?)
    end
  end
end
