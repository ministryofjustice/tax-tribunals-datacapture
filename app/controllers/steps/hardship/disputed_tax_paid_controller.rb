module Steps::Hardship
  class DisputedTaxPaidController < Steps::HardshipStepController
    def edit
      @form_object = DisputedTaxPaidForm.new(
        tribunal_case: current_tribunal_case,
        disputed_tax_paid: current_tribunal_case.disputed_tax_paid
      )
    end

    def update
      update_and_advance(DisputedTaxPaidForm)
    end
  end
end
