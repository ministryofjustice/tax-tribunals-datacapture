require 'rails_helper'

RSpec.describe Steps::Cost::CaseTypeUnchallengedController, type: :controller do
    it_behaves_like 'an intermediate step controller', Steps::Cost::CaseTypeForm
end
