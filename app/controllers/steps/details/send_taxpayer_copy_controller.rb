module Steps::Details
  class SendTaxpayerCopyController < Steps::DetailsStepController
    def edit
      @form_object = SendApplicationDetailsForm.new(
        tribunal_case: current_tribunal_case,
        send_application_details: current_tribunal_case.send_taxpayer_copy,
        email_address:,
        phone_number:,
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

    def email_address
      current_tribunal_case.taxpayer_contact_email if current_tribunal_case.send_taxpayer_copy?
    end

    def phone_number
      current_tribunal_case.taxpayer_contact_phone if current_tribunal_case.send_taxpayer_text_copy?
    end
  end
end
