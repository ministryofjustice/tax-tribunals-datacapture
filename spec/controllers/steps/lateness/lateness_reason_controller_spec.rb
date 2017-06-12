require 'rails_helper'

RSpec.describe Steps::Lateness::LatenessReasonController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Lateness::LatenessReasonForm, TaxTribs::LatenessDecisionTree
end
