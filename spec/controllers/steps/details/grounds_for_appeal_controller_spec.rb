require 'rails_helper'

RSpec.describe Steps::Details::GroundsForAppealController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Details::GroundsForAppealForm, DetailsDecisionTree
end
