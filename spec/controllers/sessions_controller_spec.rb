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

  describe '#create_and_fill_cost' do
    before do
      expect(Rails.env).to receive(:development?).at_least(:once).and_return(false)
    end

    it 'will not work in a non-development environment' do
      expect { post :create_and_fill_cost }.to raise_error(RuntimeError)
    end
  end

  describe '#create_and_fill_cost_and_lateness' do
    before do
      expect(Rails.env).to receive(:development?).at_least(:once).and_return(false)
    end

    it 'will not work in a non-development environment' do
      expect { post :create_and_fill_cost_and_lateness }.to raise_error(RuntimeError)
    end
  end
end
