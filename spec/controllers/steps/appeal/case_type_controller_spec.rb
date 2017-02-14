require 'rails_helper'

RSpec.describe Steps::Appeal::CaseTypeController, type: :controller do
  it_behaves_like 'a start point step controller', Steps::Appeal::CaseTypeForm, AppealDecisionTree
end
