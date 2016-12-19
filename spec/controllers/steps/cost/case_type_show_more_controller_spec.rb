require 'rails_helper'

RSpec.describe Steps::Cost::CaseTypeShowMoreController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Cost::CaseTypeShowMoreForm, CostDecisionTree
end
