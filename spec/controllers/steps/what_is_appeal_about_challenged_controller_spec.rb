require 'rails_helper'

RSpec.describe Steps::WhatIsAppealAboutChallengedController, type: :controller do
  it_behaves_like 'an intermediate step controller', WhatIsAppealAboutForm
end
