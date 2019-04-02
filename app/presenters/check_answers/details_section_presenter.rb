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
        *support_answers,
        *submitted_letter_files_answers
      ].select(&:show?)
    end

    private

    def submitted_letter_files_answers
      if tribunal_case.letter_upload_type == LetterUploadType::MULTIPLE
        [
          DocumentsSubmittedAnswer.new(:letter_uploaded, tribunal_case.documents(:supporting_documents), change_path: edit_steps_details_documents_upload_path),
          Answer.new(:problems_uploading_letter, tribunal_case.having_problems_uploading_explanation, raw: true, change_path: edit_steps_details_documents_upload_path)
        ]
      else
        [
          DocumentsSubmittedAnswer.new(:letter_uploaded, tribunal_case.documents(:supporting_letter), change_path: edit_steps_details_letter_upload_path),
          Answer.new(:problems_uploading_letter, tribunal_case.having_problems_uploading_explanation, raw: true, change_path: edit_steps_details_letter_upload_path)
        ]
      end
    end

    def support_answers
      [
        Answer.new(:need_support, tribunal_case.need_support, change_path: edit_steps_details_need_support_path),
        MultiAnswer.new(:what_support, what_support_with_other, change_path: edit_steps_details_what_support_path),
      ] if tribunal_case.need_support == NeedSupport::YES.to_s
    end

    def what_support
      [
        :language_interpreter,
        :sign_language_interpreter,
        :hearing_loop,
        :disabled_access,
        :other_support,
      ].select { |support| tribunal_case[support] }
    end

    def what_support_with_other
      what_support.tap do |choices|
        choices << tribunal_case.other_support_details if tribunal_case.other_support
      end
    end
  end
end
