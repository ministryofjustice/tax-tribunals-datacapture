module Steps::Lateness
  class LatenessReasonController < Steps::LatenessStepController
    def edit
      @form_object = LatenessReasonForm.new(
        tribunal_case:   current_tribunal_case,
        lateness_reason: current_tribunal_case.lateness_reason
      )
    end

    def update
      update_and_advance(LatenessReasonForm)
    end
  end
end
