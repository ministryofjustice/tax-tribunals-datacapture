require 'rails_helper'

RSpec.describe Steps::WhatIsDisputeAboutController, type: :controller do
    it_behaves_like 'an intermediate step controller', WhatIsDisputeAboutForm
end
