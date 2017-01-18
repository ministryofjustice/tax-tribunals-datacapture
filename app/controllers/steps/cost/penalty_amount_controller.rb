module Steps::Cost
  class PenaltyAmountController < Steps::CostStepController
    def edit
      super
      @form_object = PenaltyAmountForm.new(
        tribunal_case: current_tribunal_case,
        penalty_level: current_tribunal_case.penalty_level
      )
    end

    def update
      update_and_advance(PenaltyAmountForm, as: :penalty_amount)
    end
  end
end
