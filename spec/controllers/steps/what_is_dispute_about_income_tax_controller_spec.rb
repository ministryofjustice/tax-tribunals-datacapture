require 'rails_helper'

RSpec.describe Steps::WhatIsDisputeAboutIncomeTaxController, type: :controller do
    it_behaves_like 'an intermediate step controller', WhatIsDisputeAboutIncomeTaxForm
end
