module Steps::Details
  class OrganisationDetailsController < Steps::DetailsStepController
    def edit
      super
      @form_object = OrganisationTaxpayerDetailsForm.new(
        tribunal_case:                             current_tribunal_case,
        taxpayer_organisation_name:                current_tribunal_case.taxpayer_organisation_name,
        taxpayer_organisation_registration_number: current_tribunal_case.taxpayer_organisation_registration_number,
        taxpayer_organisation_fao:                 current_tribunal_case.taxpayer_organisation_fao,
        taxpayer_contact_address:                  current_tribunal_case.taxpayer_contact_address,
        taxpayer_contact_postcode:                 current_tribunal_case.taxpayer_contact_postcode,
        taxpayer_contact_email:                    current_tribunal_case.taxpayer_contact_email,
        taxpayer_contact_phone:                    current_tribunal_case.taxpayer_contact_phone
      )
    end

    def update
      update_and_advance(OrganisationTaxpayerDetailsForm, as: :organisation_details)
    end
  end
end
