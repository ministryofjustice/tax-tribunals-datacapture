require 'rails_helper'

RSpec.describe Steps::WhatIsLatePenaltyOrSurchargeController, type: :controller do
    it_behaves_like 'an intermediate step controller', WhatIsLatePenaltyOrSurchargeForm
end
