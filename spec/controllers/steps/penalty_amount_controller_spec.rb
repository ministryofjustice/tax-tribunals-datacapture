require 'rails_helper'

RSpec.describe Steps::PenaltyAmountController, type: :controller do
    it_behaves_like 'an intermediate step controller', PenaltyAmountForm
end
