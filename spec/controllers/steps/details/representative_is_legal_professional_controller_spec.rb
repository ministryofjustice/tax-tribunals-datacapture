require 'rails_helper'

RSpec.describe Steps::Details::RepresentativeIsLegalProfessionalController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Details::RepresentativeIsLegalProfessionalForm, DetailsDecisionTree
end
