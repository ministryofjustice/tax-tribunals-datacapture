require 'spec_helper'

RSpec.describe Steps::Details::OrganisationTaxpayerDetailsForm do
  it_behaves_like 'a contactable entity form',
    entity_type: :taxpayer,
    additional_fields: [
      :taxpayer_organisation_name,
      :taxpayer_organisation_registration_number,
      :taxpayer_organisation_fao
    ]
end
