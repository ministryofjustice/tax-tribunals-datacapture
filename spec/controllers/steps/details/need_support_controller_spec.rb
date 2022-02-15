require 'rails_helper'

RSpec.describe Steps::Details::NeedSupportController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Shared::NeedSupportForm, DetailsDecisionTree
end
