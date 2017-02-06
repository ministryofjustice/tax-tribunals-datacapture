module Steps::Details
  class RepresentativeDetailsController < Steps::DetailsStepController
    def edit
      super
      @form_object = form_klass.new(
        tribunal_case: current_tribunal_case,
        # Values for all possible form objects are here, as irrelevant ones will simply be
        # discarded by the concrete implementation
        representative_individual_first_name: current_tribunal_case.representative_individual_first_name,
        representative_individual_last_name: current_tribunal_case.representative_individual_last_name,
        representative_organisation_name: current_tribunal_case.representative_organisation_name,
        representative_organisation_registration_number: current_tribunal_case.representative_organisation_registration_number,
        representative_organisation_fao: current_tribunal_case.representative_organisation_fao,
        representative_contact_address: current_tribunal_case.representative_contact_address,
        representative_contact_postcode: current_tribunal_case.representative_contact_postcode,
        representative_contact_email: current_tribunal_case.representative_contact_email,
        representative_contact_phone: current_tribunal_case.representative_contact_phone
      )
    end

    def update
      update_and_advance(form_klass, as: :representative_details)
    end

    private

    def form_klass
      case current_tribunal_case.representative_type
      when ContactableEntityType::INDIVIDUAL
        RepresentativeIndividualDetailsForm
      when ContactableEntityType::COMPANY
        RepresentativeCompanyDetailsForm
      when ContactableEntityType::OTHER_ORGANISATION
        RepresentativeOrganisationDetailsForm
      end
    end
  end
end
