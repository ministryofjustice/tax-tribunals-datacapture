module Steps::Details
  class RepresentativeProfessionalStatusController < Steps::DetailsStepController
    def edit
      @form_object = RepresentativeProfessionalStatusForm.new(
        tribunal_case: current_tribunal_case,
        representative_professional_status: current_tribunal_case.representative_professional_status
      )
    end

    def update
      update_and_advance(RepresentativeProfessionalStatusForm)
    end
  end
end
