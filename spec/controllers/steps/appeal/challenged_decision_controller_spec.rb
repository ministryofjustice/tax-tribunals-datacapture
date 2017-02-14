require 'rails_helper'

RSpec.describe Steps::Appeal::ChallengedDecisionController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Appeal::ChallengedDecisionForm, AppealDecisionTree
end
