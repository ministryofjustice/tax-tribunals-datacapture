require 'rails_helper'

RSpec.describe DecisionsController, type: :controller do
  describe '#show' do
    it 'is successful' do
      get :show, params: { id: 1 }
      expect(response).to be_successful
    end
  end
end
