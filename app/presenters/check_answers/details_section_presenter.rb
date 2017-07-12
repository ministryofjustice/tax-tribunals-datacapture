module CheckAnswers
  class DetailsSectionPresenter < SectionPresenter
    def name
      :details
    end

    def answers
      [
        FileOrTextAnswer.new(:grounds_for_appeal, tribunal_case.grounds_for_appeal, tribunal_case.documents(:grounds_for_appeal).first, change_path: edit_steps_details_grounds_for_appeal_path),
        # nil file because there is no file upload field (yet)
        FileOrTextAnswer.new(:outcome, tribunal_case.outcome, nil, change_path: edit_steps_details_outcome_path),
        DocumentsSubmittedAnswer.new(:letter_submitted, tribunal_case.documents(:supporting_letter), change_path: edit_steps_details_letter_upload_path),
        Answer.new(:problems_uploading_letter, tribunal_case.having_problems_uploading_explanation, raw: true, change_path: edit_steps_details_letter_upload_path)
      ].select(&:show?)
    end
  end
end
