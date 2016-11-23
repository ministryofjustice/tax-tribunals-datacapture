require 'rails_helper'

RSpec.describe Steps::Cost::CaseTypeChallengedController, type: :controller do
  it_behaves_like 'an intermediate step controller', CaseTypeForm, CostDecisionTree
end
