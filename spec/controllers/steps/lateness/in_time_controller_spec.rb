require 'rails_helper'

RSpec.describe Steps::Lateness::InTimeController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Lateness::InTimeForm, TaxTribs::LatenessDecisionTree
end
