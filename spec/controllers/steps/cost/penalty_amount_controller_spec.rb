require 'rails_helper'

RSpec.describe Steps::Cost::PenaltyAmountController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Cost::PenaltyAmountForm
end
