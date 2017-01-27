require 'spec_helper'

RSpec.describe Steps::Details::OrganisationTaxpayerDetailsForm do
  it_behaves_like 'a contactable entity',
    entity_type: :taxpayer,
    additional_fields: [
      :taxpayer_company_name,
      :taxpayer_company_registration_number,
      :taxpayer_company_fao
    ]
end
