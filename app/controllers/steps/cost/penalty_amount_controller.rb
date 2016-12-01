module Steps::Cost
  class PenaltyAmountController < Steps::CostStepController
    def edit
      super
      @form_object = PenaltyAmountForm.new(
        tribunal_case: current_tribunal_case,
        penalty_amount: current_tribunal_case.penalty_amount
      )
    end

    def update
      update_and_advance(:penalty_amount, PenaltyAmountForm, as: :penalty_amount)
    end

    def previous_step_path
      edit_steps_cost_dispute_type_path
    end
  end
end
