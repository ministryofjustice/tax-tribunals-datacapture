require 'spec_helper'

RSpec.describe Steps::Details::IndividualTaxpayerDetailsForm do
  it_behaves_like 'a contactable entity',
    entity_type: :taxpayer,
    additional_fields: [
      :taxpayer_individual_name
    ]
end
