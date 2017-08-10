require 'rails_helper'

RSpec.describe Steps::Details::LetterUploadTypeController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Details::LetterUploadTypeForm, DetailsDecisionTree
end
