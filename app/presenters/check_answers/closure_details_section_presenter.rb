module CheckAnswers
  class ClosureDetailsSectionPresenter < SectionPresenter
    def name
      :closure_details
    end

    def answers
      [
        Answer.new(:closure_hmrc_reference, tribunal_case.closure_hmrc_reference, change_path: edit_steps_closure_enquiry_details_path, raw: true),
        Answer.new(:closure_years_under_enquiry, tribunal_case.closure_years_under_enquiry, raw: true),
        Answer.new(:closure_hmrc_officer, tribunal_case.closure_hmrc_officer, raw: true),
        # nil file because no upload option (yet)
        FileOrTextAnswer.new(:closure_additional_info, tribunal_case.closure_additional_info, nil, change_path: edit_steps_closure_additional_info_path),
        DocumentsSubmittedAnswer.new(:documents_submitted, tribunal_case.documents(:supporting_documents), change_path: edit_steps_closure_support_documents_path)
      ].select(&:show?)
    end
  end
end
