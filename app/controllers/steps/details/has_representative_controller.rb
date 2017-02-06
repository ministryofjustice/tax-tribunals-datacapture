module Steps::Details
  class HasRepresentativeController < Steps::DetailsStepController
    def edit
      super
      @form_object = HasRepresentativeForm.new(
        tribunal_case: current_tribunal_case,
        has_representative: current_tribunal_case.has_representative
      )
    end

    def update
      update_and_advance(HasRepresentativeForm)
    end
  end
end
