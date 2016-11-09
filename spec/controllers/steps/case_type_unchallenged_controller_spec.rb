require 'rails_helper'

RSpec.describe Steps::CaseTypeUnchallengedController, type: :controller do
    it_behaves_like 'an intermediate step controller', CaseTypeForm
end
