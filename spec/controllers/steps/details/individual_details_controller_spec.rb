require 'rails_helper'

RSpec.describe Steps::Details::IndividualDetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Details::IndividualDetailsForm, DetailsDecisionTree
end
