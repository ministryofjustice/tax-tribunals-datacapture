module Steps::Lateness
  class LatenessReasonController < Steps::LatenessStepController
    def edit
      super
      @form_object = LatenessReasonForm.new(
        tribunal_case:   current_tribunal_case,
        lateness_reason: current_tribunal_case.lateness_reason
      )
    end

    def update
      update_and_advance(:lateness_reason, LatenessReasonForm)
    end

    def previous_step_path
      edit_steps_lateness_in_time_path
    end
  end
end
