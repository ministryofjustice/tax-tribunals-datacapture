require 'rails_helper'

RSpec.describe Steps::Closure::AdditionalInfoController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Closure::AdditionalInfoForm, ClosureDecisionTree
end
