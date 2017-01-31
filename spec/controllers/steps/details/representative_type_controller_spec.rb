require 'rails_helper'

RSpec.describe Steps::Details::RepresentativeTypeController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Details::RepresentativeTypeForm, DetailsDecisionTree
end
