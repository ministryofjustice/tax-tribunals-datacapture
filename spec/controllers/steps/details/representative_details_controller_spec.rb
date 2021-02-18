require 'rails_helper'

RSpec.describe Steps::Details::RepresentativeDetailsController, type: :controller do
  before do
    stub_request(:post, "https://api.os.uk/oauth2/token/v1")
    allow(controller).to receive(:current_tribunal_case).and_return(tribunal_case)
  end

  context 'given an individual representative' do
    let(:tribunal_case) { TribunalCase.new(representative_type: ContactableEntityType::INDIVIDUAL) }

    it_behaves_like 'an intermediate step controller', Steps::Details::RepresentativeIndividualDetailsForm, DetailsDecisionTree
  end

  context 'given a company representative' do
    let(:tribunal_case) { TribunalCase.new(representative_type: ContactableEntityType::COMPANY) }

    it_behaves_like 'an intermediate step controller', Steps::Details::RepresentativeCompanyDetailsForm, DetailsDecisionTree
  end

  context 'given an organisation representative' do
    let(:tribunal_case) { TribunalCase.new(representative_type: ContactableEntityType::OTHER_ORGANISATION) }

    it_behaves_like 'an intermediate step controller', Steps::Details::RepresentativeOrganisationDetailsForm, DetailsDecisionTree
  end
end
