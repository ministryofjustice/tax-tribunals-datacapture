require 'rails_helper'

RSpec.describe Steps::Details::TaxpayerTypeController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Details::TaxpayerTypeForm, DetailsDecisionTree
end
