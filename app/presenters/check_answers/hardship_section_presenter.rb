module CheckAnswers
  class HardshipSectionPresenter < SectionPresenter
    def name
      :hardship
    end

    def show?
      # Only show if at least the first question was asked
      tribunal_case.disputed_tax_paid?
    end

    def answers
      [
        Answer.new(:disputed_tax_paid, tribunal_case.disputed_tax_paid, change_path: edit_steps_hardship_disputed_tax_paid_path),
        Answer.new(:hardship_review_requested, tribunal_case.hardship_review_requested, change_path: edit_steps_hardship_hardship_review_requested_path),
        Answer.new(:hardship_review_status, tribunal_case.hardship_review_status, change_path: edit_steps_hardship_hardship_review_status_path),
        FileOrTextAnswer.new(:hardship_reason, tribunal_case.hardship_reason, tribunal_case.documents(:hardship_reason).first, change_path: edit_steps_hardship_hardship_reason_path)
      ].select(&:show?)
    end
  end
end
