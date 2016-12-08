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
      update_and_advance(PenaltyAmountForm)
    end
  end
end
