require 'rails_helper'

RSpec.describe Steps::Details::SendRepresentativeCopyController, type: :controller do
  let(:tribunal_case) { TribunalCase.new(taxpayer_type: UserType::REPRESENTATIVE) }
  before do
    allow(controller).to receive(:current_tribunal_case).and_return(tribunal_case)
  end

  it_behaves_like 'an intermediate step controller', Steps::Details::SendApplicationDetailsForm, DetailsDecisionTree
end
