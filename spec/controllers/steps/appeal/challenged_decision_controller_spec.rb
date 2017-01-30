require 'rails_helper'

RSpec.describe Steps::Appeal::ChallengedDecisionController, type: :controller do
  it_behaves_like 'a start point step controller', Steps::Appeal::ChallengedDecisionForm, AppealDecisionTree
end
