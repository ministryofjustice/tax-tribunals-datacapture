require 'rails_helper'

RSpec.describe Steps::Appeal::PenaltyAmountController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Appeal::PenaltyAmountForm, AppealDecisionTree
end
