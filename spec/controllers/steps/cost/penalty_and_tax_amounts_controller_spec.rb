require 'rails_helper'

RSpec.describe Steps::Cost::PenaltyAndTaxAmountsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Cost::PenaltyAndTaxAmountsForm, CostDecisionTree
end
