module Steps::Details
  class RepresentativeTypeController < Steps::DetailsStepController
    def edit
      @form_object = RepresentativeTypeForm.new(
        tribunal_case: current_tribunal_case,
        representative_type: current_tribunal_case.representative_type
      )
    end

    def update
      update_and_advance(RepresentativeTypeForm)
    end
  end
end
