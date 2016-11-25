module Steps::Details
  class TaxpayerTypeController < Steps::DetailsStepController
    def edit
      super
      @form_object = TaxpayerTypeForm.new(
        tribunal_case: current_tribunal_case,
        taxpayer_type: current_tribunal_case.taxpayer_type
      )
      @back_link_path = steps_details_start_path
    end

    def update
      update_and_advance(:taxpayer_type, TaxpayerTypeForm)
    end
  end
end
