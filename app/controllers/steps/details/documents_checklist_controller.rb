module Steps::Details
  class DocumentsChecklistController < Steps::DetailsStepController
    before_action :set_documents_list, only: [:edit, :update]

    def edit
      super
      @form_object = DocumentsChecklistForm.new(
        tribunal_case: current_tribunal_case,
        original_notice_provided: current_tribunal_case.original_notice_provided,
        review_conclusion_provided: current_tribunal_case.review_conclusion_provided,
        additional_documents_provided: current_tribunal_case.additional_documents_provided,
        additional_documents_info: current_tribunal_case.additional_documents_info,
        having_problems_uploading_documents: current_tribunal_case.having_problems_uploading_documents
      )
    end

    def update
      update_and_advance(DocumentsChecklistForm, as: :documents_checklist)
    end

    private

    def set_documents_list
      @document_list = current_tribunal_case&.documents || []
    end
  end
end
