require 'rails_helper'

RSpec.describe Steps::Details::DocumentsChecklistController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Details::DocumentsChecklistForm, DetailsDecisionTree
end
