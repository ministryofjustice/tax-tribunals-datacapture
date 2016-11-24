require 'rails_helper'

RSpec.describe Steps::Cost::DisputeTypeController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Cost::DisputeTypeForm, CostDecisionTree
end
