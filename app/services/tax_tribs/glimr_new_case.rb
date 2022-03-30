require 'glimr_api_client'

module TaxTribs
  class GlimrNewCase
    attr_reader :tribunal_case, :case_reference, :confirmation_code
    alias_attribute :tc, :tribunal_case

    def initialize(tribunal_case)
      @tribunal_case = tribunal_case
    end

    def call
      # TEMPORARILY REMOVE GLIMR - MUST NOT GO TO PRODUCTION
      # DATE: 30 MARCH 2022 - 7th APRIL 2022

      # REASON: WE ARE TEMPORARILY USING STAGING FOR
      # GLIMR MASS UPLOAD WHILE WE FIX THE STAGING -> PRODUCTION
      # DEPLOYMENT PIPELINE

      # UNCOMMENT THIS TO REACTIVATE IF YOU MUST DEPLOY TO PRODUCTION
      # IN AN EMERGENCY

      # GlimrApiClient::RegisterNewCase.call(params).tap { |api|
      #   @case_reference = api.response_body.fetch(:tribunalCaseNumber)
      #   @confirmation_code = api.response_body.fetch(:confirmationCode)
      # }
      self
    rescue => e
      Rails.logger.info({ caller: self.class.name, method: __callee__, error: e }.to_json)
      Sentry.capture_exception(e)
      self
    end

    def params
      params = {
        jurisdictionId: jurisdiction_id,
        onlineMappingCode: tc.mapping_code.to_glimr_str,
        contactPhone: tc.taxpayer_contact_phone,
        contactEmail: tc.taxpayer_contact_email,
        contactPostalCode: tc.taxpayer_contact_postcode,
        contactCity: tc.taxpayer_contact_city,
        contactCountry: tc.taxpayer_contact_country,
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

      params.merge!(representative_params) if tc.has_representative?
      params
    end

    def representative_params
      params = {
        repPhone: tc.representative_contact_phone,
        repEmail: tc.representative_contact_email,
        repPostalCode: tc.representative_contact_postcode,
        repCity: tc.representative_contact_city,
        repCountry: tc.representative_contact_country
      }

      params.merge!(representative_street_params)

      if tc.representative_is_organisation?
        params.merge!(
          repOrganisationName: tc.representative_organisation_name,
          repFAO: tc.representative_organisation_fao
        )
      else
        params.merge!(
          repFirstName: tc.representative_individual_first_name,
          repLastName: tc.representative_individual_last_name
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
      street1, street2, street3, street4 = split_address(tc.taxpayer_contact_address)

      {
        contactStreet1: street1,
        contactStreet2: street2,
        contactStreet3: street3,
        contactStreet4: street4
      }.compact
    end

    def representative_street_params
      street1, street2, street3, street4 = split_address(tc.representative_contact_address)

      {
        repStreet1: street1,
        repStreet2: street2,
        repStreet3: street3,
        repStreet4: street4
      }.compact
    end

    def split_address(address)
      lines = address.lines.map(&:chomp)

      street1, street2, street3, *remnant = lines
      street4 = remnant.join(', ').presence

      [street1, street2, street3, street4]
    end
  end
end
