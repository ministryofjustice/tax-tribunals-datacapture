module Steps::Appeal
  class PenaltyAndTaxAmountsController < Steps::AppealStepController
    def edit
      super
      @form_object = PenaltyAndTaxAmountsForm.new(
        tribunal_case:  current_tribunal_case,
        penalty_amount: current_tribunal_case.penalty_amount,
        tax_amount:     current_tribunal_case.tax_amount
      )
    end

    def update
      update_and_advance(PenaltyAndTaxAmountsForm, as: :penalty_and_tax_amounts)
    end
  end
end
