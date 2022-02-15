require 'rails_helper'

RSpec.describe Steps::Closure::WhatSupportController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Shared::WhatSupportForm, TaxTribs::ClosureDecisionTree
end
