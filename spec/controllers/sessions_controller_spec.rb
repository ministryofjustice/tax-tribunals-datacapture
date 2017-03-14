require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe '#ping' do
    it 'does nothing' do
      get :ping
      expect(response).to have_http_status(:no_content)
    end
  end

  describe '#destroy' do
    it 'resets the session' do
      get :destroy, session: { foo: 'BAR' }
      expect(session).to be_empty
    end

    it 'redirects to the home page' do
      get :destroy
      expect(subject).to redirect_to(root_path)
    end

    context 'when survey param is provided' do
      it 'redirects to the survey page' do
        get :destroy, params: {survey: true}
        expect(response.location).to match(/goo\.gl\/forms/)
      end
    end
  end

  [
    'create_and_fill_appeal',
    'create_and_fill_appeal_and_lateness',
    'create_and_fill_appeal_and_lateness_and_appellant'
  ].each do |method|
    describe "##{method}" do
      before do
        expect(Rails.env).to receive(:development?).at_least(:once).and_return(false)
      end

      it 'will not work in a non-development environment' do
        expect { post method.to_sym }.to raise_error(RuntimeError)
      end
    end
  end

end
