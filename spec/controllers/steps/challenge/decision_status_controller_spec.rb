require 'rails_helper'

RSpec.describe Steps::Challenge::DecisionStatusController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Challenge::DecisionStatusForm, ChallengeDecisionTree
end
