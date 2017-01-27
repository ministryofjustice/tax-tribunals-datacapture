require 'rails_helper'

RSpec.describe Steps::Appeal::PenaltyAndTaxAmountsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Appeal::PenaltyAndTaxAmountsForm, AppealDecisionTree
end
