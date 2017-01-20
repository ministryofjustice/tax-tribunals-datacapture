require 'rails_helper'

RSpec.describe Steps::Cost::TaxAmountController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Cost::TaxAmountForm, CostDecisionTree
end
