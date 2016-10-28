require 'rails_helper'

RSpec.describe Steps::DidChallengeHmrcController, type: :controller do
  it_behaves_like 'an entrypoint step controller', DidChallengeHmrcForm
end
