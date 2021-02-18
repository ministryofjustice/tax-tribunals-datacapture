module Steps::Details
  class TaxpayerDetailsController < Steps::DetailsStepController
    before_action :address_lookup_access_token, only: [:edit]

    def edit
      @form_object = form_klass.new(
        tribunal_case: current_tribunal_case,
        # Values for all possible form objects are here, as irrelevant ones will simply be
        # discarded by the concrete implementation
        taxpayer_individual_first_name: current_tribunal_case.taxpayer_individual_first_name,
        taxpayer_individual_last_name: current_tribunal_case.taxpayer_individual_last_name,
        taxpayer_organisation_name: current_tribunal_case.taxpayer_organisation_name,
        taxpayer_organisation_registration_number: current_tribunal_case.taxpayer_organisation_registration_number,
        taxpayer_organisation_fao: current_tribunal_case.taxpayer_organisation_fao,
        taxpayer_contact_address: current_tribunal_case.taxpayer_contact_address,
        taxpayer_contact_postcode: current_tribunal_case.taxpayer_contact_postcode,
        taxpayer_contact_city: current_tribunal_case.taxpayer_contact_city,
        taxpayer_contact_country: current_tribunal_case.taxpayer_contact_country,
        taxpayer_contact_email: current_tribunal_case.taxpayer_contact_email,
        taxpayer_contact_phone: current_tribunal_case.taxpayer_contact_phone
      )
    end

    def update
      update_and_advance(form_klass, as: :taxpayer_details)
    end

    private

    def form_klass
      case current_tribunal_case.taxpayer_type
      when ContactableEntityType::INDIVIDUAL
        TaxpayerIndividualDetailsForm
      when ContactableEntityType::COMPANY
        TaxpayerCompanyDetailsForm
      when ContactableEntityType::OTHER_ORGANISATION
        TaxpayerOrganisationDetailsForm
      end
    end
  end
end
