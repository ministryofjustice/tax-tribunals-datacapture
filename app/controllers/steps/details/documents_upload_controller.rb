module Steps::Details
  class DocumentsUploadController < Steps::DetailsStepController
    helper LetterTypeHelper

    before_action :set_documents_list, only: [:edit, :update]

    def edit
      @form_object = DocumentsUploadForm.new(
        tribunal_case: current_tribunal_case,
        having_problems_uploading: current_tribunal_case.having_problems_uploading,
        having_problems_uploading_explanation: current_tribunal_case.having_problems_uploading_explanation
      )
    end

    def update
      update_and_advance(DocumentsUploadForm, as: :documents_upload)
    end

    private

    def set_documents_list
      @documents_list = current_tribunal_case&.documents(:supporting_documents) || []
    end
  end
end
