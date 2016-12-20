require 'rails_helper'

RSpec.describe Steps::Hardship::DisputedTaxPaidController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Hardship::DisputedTaxPaidForm, HardshipDecisionTree
end
