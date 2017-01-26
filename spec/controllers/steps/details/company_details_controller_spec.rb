require 'rails_helper'

RSpec.describe Steps::Details::CompanyDetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Details::OrganisationTaxpayerDetailsForm, DetailsDecisionTree
end
