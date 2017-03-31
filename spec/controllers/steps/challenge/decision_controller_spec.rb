require 'rails_helper'

RSpec.describe Steps::Challenge::DecisionController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Challenge::DecisionForm, ChallengeDecisionTree
end
