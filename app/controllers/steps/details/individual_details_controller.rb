module Steps::Details
  class IndividualDetailsController < Steps::DetailsStepController
    def edit
      super
      @form_object = IndividualDetailsForm.new(
        tribunal_case:             current_tribunal_case,
        taxpayer_individual_name:  current_tribunal_case.taxpayer_individual_name,
        taxpayer_contact_address:  current_tribunal_case.taxpayer_contact_address,
        taxpayer_contact_postcode: current_tribunal_case.taxpayer_contact_postcode,
        taxpayer_contact_email:    current_tribunal_case.taxpayer_contact_email,
        taxpayer_contact_phone:    current_tribunal_case.taxpayer_contact_phone
      )
    end

    def update
      update_and_advance(:individual_details, IndividualDetailsForm, as: :individual_details)
    end
  end
end
