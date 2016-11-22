require 'rails_helper'

RSpec.describe Steps::Cost::ChallengedDecisionController, type: :controller do
  it_behaves_like 'a start point step controller', Steps::Cost::ChallengedDecisionForm
end
