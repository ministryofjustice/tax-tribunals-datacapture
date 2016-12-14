require 'glimr_api_client'

class CaseCreator
  attr_reader :tribunal_case, :errors
  attr_reader :tc_number, :conf_code, :payment_url

  alias_attribute :tc, :tribunal_case

  def initialize(tribunal_case)
    @tribunal_case = tribunal_case
    @errors = []
  end

  def call
    create_glimr_case!
    retrieve_payment_url!
    !errors?
  end

  def errors?
    errors.any?
  end

  private

  def create_glimr_case!
    response = GlimrApiClient::RegisterNewCase.call(case_params)
    @tc_number = response.response_body[:tribunalCaseNumber]
    @conf_code = response.response_body[:confirmationCode]
  rescue => ex
    errors << ex.message
  end

  def retrieve_payment_url!
    return if errors?

    # TODO: call the other API to store the tc_number and conf_code
    # and get back the url to redirect back the user
    @payment_url = 'http://www.example.com'
  end

  def taxpayer_is_company?
    tc.taxpayer_type == TaxpayerType::COMPANY
  end

  # TODO: find out where to obtain all the required information
  def case_params
    {
      jurisdictionId: GlimrApiClient::Case::TRIBUNAL_JURISDICTION_ID,
      onlineMappingCode: tc.case_type,
      contactFirstName: tc.taxpayer_individual_name,
      contactLastName: nil,
      contactPhone: tc.taxpayer_contact_phone,
      contactEmail: tc.taxpayer_contact_email,
      contactStreet1: tc.taxpayer_contact_address,
      contactPostalCode: tc.taxpayer_contact_postcode,
      contactCity: nil
    }.tap do |params|
      params.merge!(
        repOrganisationName: tc.taxpayer_company_name,
        repFAO: tc.taxpayer_company_fao
      ) if taxpayer_is_company?
    end
  end
end
