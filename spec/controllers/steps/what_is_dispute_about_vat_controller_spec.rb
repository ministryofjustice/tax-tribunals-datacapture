require 'rails_helper'

RSpec.describe Steps::WhatIsDisputeAboutVatController, type: :controller do
    it_behaves_like 'an intermediate step controller', WhatIsDisputeAboutVatForm
end
