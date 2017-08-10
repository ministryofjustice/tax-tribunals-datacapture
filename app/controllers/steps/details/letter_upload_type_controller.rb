module Steps::Details
  class LetterUploadTypeController < Steps::DetailsStepController
    helper LetterTypeHelper

    def edit
      @form_object = LetterUploadTypeForm.new(
        tribunal_case: current_tribunal_case,
        letter_upload_type: current_tribunal_case.letter_upload_type
      )
    end

    def update
      update_and_advance(LetterUploadTypeForm, as: :letter_upload_type)
    end
  end
end
