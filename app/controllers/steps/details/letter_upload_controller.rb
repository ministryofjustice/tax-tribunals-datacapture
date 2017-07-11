module Steps::Details
  class LetterUploadController < Steps::DetailsStepController
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
  end
end
