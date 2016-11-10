require 'rails_helper'

RSpec.describe Steps::ChallengedDecisionController, type: :controller do
  it_behaves_like 'a start point step controller', ChallengedDecisionForm
end
