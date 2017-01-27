require 'rails_helper'

RSpec.describe Steps::Appeal::CaseTypeShowMoreController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Appeal::CaseTypeShowMoreForm, AppealDecisionTree
end
