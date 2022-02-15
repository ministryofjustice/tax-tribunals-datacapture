require 'rails_helper'

RSpec.describe Steps::Details::WhatSupportController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Shared::WhatSupportForm, DetailsDecisionTree
end
