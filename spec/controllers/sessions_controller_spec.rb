require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe '#destroy' do
    it 'resets the session' do
      get :destroy, session: { foo: 'BAR' }
      expect(session).to be_empty
    end

    it 'redirects to the start page' do
      get :destroy
      expect(subject).to redirect_to(root_path)
    end
  end
end
