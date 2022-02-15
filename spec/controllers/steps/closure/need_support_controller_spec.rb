require 'rails_helper'

RSpec.describe Steps::Closure::NeedSupportController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Shared::NeedSupportForm, TaxTribs::ClosureDecisionTree
end
