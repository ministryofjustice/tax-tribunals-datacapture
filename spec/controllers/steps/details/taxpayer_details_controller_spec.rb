require 'rails_helper'

RSpec.describe Steps::Details::TaxpayerDetailsController, type: :controller do
  before do
    allow(controller).to receive(:current_tribunal_case).and_return(tribunal_case)
  end

  context 'given an individual taxpayer' do
    let(:tribunal_case) { TribunalCase.new(taxpayer_type: ContactableEntityType::INDIVIDUAL) }

    it_behaves_like 'an intermediate step controller', Steps::Details::TaxpayerIndividualDetailsForm, DetailsDecisionTree
  end

  context 'given a company taxpayer' do
    let(:tribunal_case) { TribunalCase.new(taxpayer_type: ContactableEntityType::COMPANY) }

    it_behaves_like 'an intermediate step controller', Steps::Details::TaxpayerCompanyDetailsForm, DetailsDecisionTree
  end

  context 'given an organisation taxpayer' do
    let(:tribunal_case) { TribunalCase.new(taxpayer_type: ContactableEntityType::OTHER_ORGANISATION) }

    it_behaves_like 'an intermediate step controller', Steps::Details::TaxpayerOrganisationDetailsForm, DetailsDecisionTree
  end
end
