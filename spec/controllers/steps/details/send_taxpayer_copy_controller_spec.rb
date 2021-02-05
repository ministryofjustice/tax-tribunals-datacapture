require 'rails_helper'

RSpec.describe Steps::Details::SendTaxpayerCopyController, type: :controller do
  let(:tribunal_case) { TribunalCase.new(taxpayer_type: UserType::TAXPAYER) }
  before do
    allow(controller).to receive(:current_tribunal_case).and_return(tribunal_case)
  end

  it_behaves_like 'an intermediate step controller', Steps::Details::SendApplicationDetailsForm, DetailsDecisionTree
end
