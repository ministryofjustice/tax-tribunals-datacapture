module Steps::Appeal
  class DisputeTypeController < Steps::AppealStepController
    def edit
      super
      @form_object = DisputeTypeForm.new(
        tribunal_case: current_tribunal_case,
        dispute_type: current_tribunal_case.dispute_type
      )
    end

    def update
      update_and_advance(DisputeTypeForm)
    end
  end
end
