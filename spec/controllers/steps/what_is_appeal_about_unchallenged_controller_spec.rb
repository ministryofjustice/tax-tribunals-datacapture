require 'rails_helper'

RSpec.describe Steps::WhatIsAppealAboutUnchallengedController, type: :controller do
    it_behaves_like 'a non-entrypoint step controller', WhatIsAppealAboutForm
end
