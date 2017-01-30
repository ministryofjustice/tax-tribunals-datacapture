module Steps::Appeal
  class PenaltyAmountController < Steps::AppealStepController
    def edit
      super
      @form_object = PenaltyAmountForm.new(
        tribunal_case:  current_tribunal_case,
        penalty_level:  current_tribunal_case.penalty_level,
        penalty_amount: current_tribunal_case.penalty_amount,
      )
    end

    def update
      update_and_advance(PenaltyAmountForm, as: :penalty_amount)
    end
  end
end
