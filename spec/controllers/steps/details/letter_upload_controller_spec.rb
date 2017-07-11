require 'rails_helper'

RSpec.describe Steps::Details::LetterUploadController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Details::LetterUploadForm, DetailsDecisionTree
end
