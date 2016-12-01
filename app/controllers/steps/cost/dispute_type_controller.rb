module Steps::Cost
  class DisputeTypeController < Steps::CostStepController
    def edit
      super
      @form_object = DisputeTypeForm.new(
        tribunal_case: current_tribunal_case,
        dispute_type: current_tribunal_case.dispute_type
      )
    end

    def update
      update_and_advance(:dispute_type, DisputeTypeForm)
    end

    def previous_step_path
      if current_tribunal_case.challenged_decision
        edit_steps_cost_case_type_challenged_path
      else
        edit_steps_cost_case_type_unchallenged_path
      end
    end
  end
end
