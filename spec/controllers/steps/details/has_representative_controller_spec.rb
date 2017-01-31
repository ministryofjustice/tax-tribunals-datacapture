require 'rails_helper'

RSpec.describe Steps::Details::HasRepresentativeController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Details::HasRepresentativeForm, DetailsDecisionTree
end
