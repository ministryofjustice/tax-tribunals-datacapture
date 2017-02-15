module Steps::Details
  class RepresentativeApprovalController < Steps::DetailsStepController
    def edit
      super
      @form_object = RepresentativeApprovalForm.new(
        tribunal_case: current_tribunal_case
      )
    end

    def update
      update_and_advance(RepresentativeApprovalForm, as: :representative_approval)
    end
  end
end
