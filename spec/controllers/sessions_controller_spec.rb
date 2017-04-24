require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe '#ping' do
    it 'does nothing and returns 204' do
      get :ping
      expect(response).to have_http_status(:no_content)
    end
  end

  describe '#destroy' do
    context 'when survey param is not provided' do
      it 'resets the tribunal case session' do
        expect(subject).to receive(:reset_tribunal_case_session)
        get :destroy
      end

      it 'redirects to the home page' do
        get :destroy
        expect(subject).to redirect_to(root_path)
      end
    end

    context 'when survey param is provided' do
      context 'for a `true` value' do
        it 'resets the session' do
          expect(subject).to receive(:reset_session)
          get :destroy, params: {survey: true}
        end

        it 'redirects to the survey page' do
          get :destroy, params: {survey: true}
          expect(response.location).to match(/goo\.gl\/forms/)
        end
      end

      context 'for a `false` value' do
        it 'resets the tribunal case session' do
          expect(subject).to receive(:reset_tribunal_case_session)
          get :destroy, params: {survey: false}
        end

        it 'redirects to the home page' do
          get :destroy, params: {survey: false}
          expect(subject).to redirect_to(root_path)
        end
      end
    end

    context 'when a JSON request is made' do
      before { request.accept = "application/json" }

      it 'returns empty JSON and does not redirect' do
        expect(response.body).to be_empty
        expect(response.location).to be_nil
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
