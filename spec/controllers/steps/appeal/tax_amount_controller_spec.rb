require 'rails_helper'

RSpec.describe Steps::Appeal::TaxAmountController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Appeal::TaxAmountForm, AppealDecisionTree
end
