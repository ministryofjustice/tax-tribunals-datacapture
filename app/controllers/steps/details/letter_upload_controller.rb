module Steps::Details
  class LetterUploadController < Steps::DetailsStepController
    helper LetterTypeHelper

    before_action :set_documents_list, only: [:edit, :update]

    def edit
      @form_object = LetterUploadForm.new(
        tribunal_case: current_tribunal_case,
        having_problems_uploading: current_tribunal_case.having_problems_uploading,
        having_problems_uploading_explanation: current_tribunal_case.having_problems_uploading_explanation
      )
    end

    def update
      update_and_advance(LetterUploadForm, as: :letter_upload)
    end

    private

    def set_documents_list
      @document_list = current_tribunal_case&.documents(:supporting_documents) || []
    end
  end
end
