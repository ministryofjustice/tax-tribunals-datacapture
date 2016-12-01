module Steps::Cost
  class CaseTypeChallengedController < Steps::CostStepController
    def edit
      super
      @form_object = CaseTypeForm.new(
        tribunal_case: current_tribunal_case,
        case_type: current_tribunal_case.case_type
      )
    end

    def update
      update_and_advance(:case_type, CaseTypeForm, as: :case_type_challenged)
    end

    def previous_step_path
      edit_steps_cost_challenged_decision_path
    end
  end
end

