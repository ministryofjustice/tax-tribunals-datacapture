require 'rails_helper'

RSpec.describe Steps::Hardship::HardshipReviewRequestedController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Hardship::HardshipReviewRequestedForm, HardshipDecisionTree
end
