module Steps::Details
  class CompanyDetailsController < Steps::DetailsStepController
    def edit
      super
      @form_object = CompanyDetailsForm.new(
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
      update_and_advance(:company_details, CompanyDetailsForm, as: :company_details)
    end

    def previous_step_path
      edit_steps_details_taxpayer_type_path
    end
  end
end
