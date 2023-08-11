module Steps::Details
  class SendRepresentativeCopyController < Steps::DetailsStepController
    def edit
      @form_object = SendApplicationDetailsForm.new(
        tribunal_case: current_tribunal_case,
        send_application_details: current_tribunal_case.send_representative_copy,
        email_address: email_address,
        phone_number: phone_number,
        send_to: UserType::REPRESENTATIVE
      )
    end

    def update
      update_and_advance(SendApplicationDetailsForm, {as: :send_representative_copy})
    end

    private

    def permitted_params(form_class)
      super
        .to_h
        .merge(send_to: UserType::REPRESENTATIVE)
    end

    def email_address
      current_tribunal_case.representative_contact_email if current_tribunal_case.send_representative_copy?
    end

    def phone_number
      current_tribunal_case.representative_contact_phone if current_tribunal_case.send_representative_text_copy?
    end
  end
end
