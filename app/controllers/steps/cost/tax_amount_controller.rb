module Steps::Cost
  class TaxAmountController < Steps::CostStepController
    def edit
      super
      @form_object = TaxAmountForm.new(
        tribunal_case: current_tribunal_case,
        tax_amount: current_tribunal_case.tax_amount
      )
    end

    def update
      update_and_advance(TaxAmountForm)
    end
  end
end
