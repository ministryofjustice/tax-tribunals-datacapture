require 'rails_helper'

RSpec.describe Steps::Appeal::DisputeTypeController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Appeal::DisputeTypeForm, AppealDecisionTree
end
