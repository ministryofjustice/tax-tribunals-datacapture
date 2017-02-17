module Steps::Details
  class RepresentativeIsLegalProfessionalController < Steps::DetailsStepController
    def edit
      @form_object = RepresentativeIsLegalProfessionalForm.new(
        tribunal_case: current_tribunal_case,
        representative_is_legal_professional: current_tribunal_case.representative_is_legal_professional
      )
    end

    def update
      update_and_advance(RepresentativeIsLegalProfessionalForm)
    end
  end
end
