require 'rails_helper'

RSpec.describe Steps::Hardship::HardshipReasonController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Hardship::HardshipReasonForm, TaxTribs::HardshipDecisionTree
end
