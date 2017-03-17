require 'rails_helper'

RSpec.describe Steps::Details::RepresentativeProfessionalStatusController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Details::RepresentativeProfessionalStatusForm, DetailsDecisionTree
end
