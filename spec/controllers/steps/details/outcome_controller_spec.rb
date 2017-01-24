require 'rails_helper'

RSpec.describe Steps::Details::OutcomeController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Details::OutcomeForm, DetailsDecisionTree
end
