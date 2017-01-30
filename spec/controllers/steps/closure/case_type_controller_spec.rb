require 'rails_helper'

RSpec.describe Steps::Closure::CaseTypeController, type: :controller do
  it_behaves_like 'a start point step controller', Steps::Closure::CaseTypeForm, ClosureDecisionTree
end
