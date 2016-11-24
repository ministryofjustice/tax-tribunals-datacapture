require 'rails_helper'

RSpec.describe Steps::Cost::CaseTypeChallengedController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Cost::CaseTypeForm, CostDecisionTree
end
