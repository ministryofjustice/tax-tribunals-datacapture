require 'glimr_api_client'

class TaxTribs::GlimrNewCase
  attr_reader :tribunal_case, :case_reference, :confirmation_code
  alias_attribute :tc, :tribunal_case

  def initialize(tribunal_case)
    @tribunal_case = tribunal_case
  end

  def call
    GlimrApiClient::RegisterNewCase.call(params).tap { |api|
      @case_reference = api.response_body.fetch(:tribunalCaseNumber)
      @confirmation_code = api.response_body.fetch(:confirmationCode)
    }
    self
  rescue => e
    Rails.logger.info({ caller: self.class.name, method: __callee__, error: e }.to_json)
    Raven.capture_exception(e)
    self
  end

  def params
    params = {
      jurisdictionId: jurisdiction_id,
      onlineMappingCode: tc.mapping_code.to_glimr_str,
      contactPhone: tc.taxpayer_contact_phone,
      contactEmail: tc.taxpayer_contact_email,
      contactPostalCode: tc.taxpayer_contact_postcode,
      documentsURL: tc.documents_url
    }

    params.merge!(taxpayer_street_params)

    if tc.taxpayer_is_organisation?
      params.merge!(
        contactOrganisationName: tc.taxpayer_organisation_name,
        contactFAO: tc.taxpayer_organisation_fao
      )
    else
      params.merge!(
        contactFirstName: tc.taxpayer_individual_first_name,
        contactLastName: tc.taxpayer_individual_last_name
      )
    end
  end

  private

  def jurisdiction_id
    GlimrApiClient::RegisterNewCase::TRIBUNAL_JURISDICTION_ID
  end

  # contactStreetX are indexed 1 to 4, so if there are more lines than available
  # parameters, we store all the remaining lines into the contactStreet4 parameter.
  #
  def taxpayer_street_params
    lines = tc.taxpayer_contact_address.lines.map(&:chomp)

    street1, street2, street3, *remnant = lines
    street4 = remnant.join(', ').presence

    {
      contactStreet1: street1,
      contactStreet2: street2,
      contactStreet3: street3,
      contactStreet4: street4
    }.compact
  end
end