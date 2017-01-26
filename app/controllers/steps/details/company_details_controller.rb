module Steps::Details
  class CompanyDetailsController < Steps::DetailsStepController
    def edit
      super
      @form_object = OrganisationTaxpayerDetailsForm.new(
        tribunal_case:                        current_tribunal_case,
        taxpayer_company_name:                current_tribunal_case.taxpayer_company_name,
        taxpayer_company_registration_number: current_tribunal_case.taxpayer_company_registration_number,
        taxpayer_company_fao:                 current_tribunal_case.taxpayer_company_fao,
        taxpayer_contact_address:             current_tribunal_case.taxpayer_contact_address,
        taxpayer_contact_postcode:            current_tribunal_case.taxpayer_contact_postcode,
        taxpayer_contact_email:               current_tribunal_case.taxpayer_contact_email,
        taxpayer_contact_phone:               current_tribunal_case.taxpayer_contact_phone
      )
    end

    def update
      update_and_advance(OrganisationTaxpayerDetailsForm, as: :company_details)
    end
  end
end
