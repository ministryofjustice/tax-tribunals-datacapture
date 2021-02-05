module Steps::Details
  class SendTaxpayerCopyController < Steps::DetailsStepController
    def edit
      @form_object = SendApplicationDetailsForm.new(
        tribunal_case: current_tribunal_case,
        send_to: UserType::TAXPAYER
      )
    end

    def update
      update_and_advance(SendApplicationDetailsForm, {as: :send_taxpayer_copy})
    end

    private

    def permitted_params(form_class)
      super
        .to_h
        .merge(send_to: UserType::TAXPAYER)
    end
  end
end
