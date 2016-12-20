require 'glimr_api_client'

class GlimrNewCase
  attr_reader :tribunal_case, :case_reference, :confirmation_code
  alias_attribute :tc, :tribunal_case

  def initialize(tribunal_case)
    @tribunal_case = tribunal_case
  end

  def call!
    response = GlimrApiClient::RegisterNewCase.call(params)
    @case_reference = response.response_body[:tribunalCaseNumber]
    @confirmation_code = response.response_body[:confirmationCode]
  end

  def params
    params = {
      jurisdictionId: jurisdiction_id,
      onlineMappingCode: tc.case_type,
      contactPhone: tc.taxpayer_contact_phone,
      contactEmail: tc.taxpayer_contact_email,
      contactPostalCode: tc.taxpayer_contact_postcode,
      documentsURL: documents_url
    }

    params.merge!(taxpayer_street_params)

    if tc.taxpayer_is_company?
      params.merge!(
        repOrganisationName: tc.taxpayer_company_name,
        repFAO: tc.taxpayer_company_fao
      )
    else
      params.merge!(
        contactFirstName: taxpayer_first_name,
        contactLastName: taxpayer_last_name
      )
    end
  end

  private

  def jurisdiction_id
    GlimrApiClient::Case::TRIBUNAL_JURISDICTION_ID
  end

  def documents_url
    [ENV.fetch('TAX_TRIBUNALS_DOWNLOADER_URL'), tc.files_collection_ref].join('/')
  end

  def taxpayer_first_name
    tc.taxpayer_individual_name.split(' ', 2)[0]
  end

  def taxpayer_last_name
    tc.taxpayer_individual_name.split(' ', 2)[1]
  end

  # contactStreetX are indexed 1 to 4, so if there are more lines than available
  # parameters, we store all the remaining lines into the contactStreet4 parameter.
  #
  def taxpayer_street_params
    lines = tc.taxpayer_contact_address.lines.map(&:chomp)

    {
      contactStreet1: lines[0],
      contactStreet2: lines[1],
      contactStreet3: lines[2],
      contactStreet4: lines[3..-1]&.join(', ')
    }.compact
  end
end
