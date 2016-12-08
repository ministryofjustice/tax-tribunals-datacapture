module Steps::Details
  class TaxpayerTypeController < Steps::DetailsStepController
    def edit
      super
      @form_object = TaxpayerTypeForm.new(
        tribunal_case: current_tribunal_case,
        taxpayer_type: current_tribunal_case.taxpayer_type
      )
    end

    def update
      update_and_advance(TaxpayerTypeForm)
    end
  end
end
