require 'rails_helper'

RSpec.describe Steps::DidChallengeHmrcController, type: :controller do
  it_behaves_like 'a start point step controller', DidChallengeHmrcForm
end
