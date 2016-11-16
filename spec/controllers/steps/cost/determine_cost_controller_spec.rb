require 'rails_helper'

RSpec.describe Steps::Cost::DetermineCostController, type: :controller do
  let(:cost_determiner) { instance_double(CostDeterminer, lodgement_fee: nil) }
  before do
    allow(CostDeterminer).to receive(:new).and_return(cost_determiner)
  end

  it_behaves_like 'an end point step controller'
end
