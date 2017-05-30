require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe '#ping' do
    it 'does nothing and returns 204' do
      get :ping
      expect(response).to have_http_status(:no_content)
    end
  end

  RSpec.shared_examples 'logs out and redirects to survey' do |options|
    let(:method) { options.fetch(:method) }

    describe '#destroy' do
      context 'when survey param is not provided' do
        it 'resets the tribunal case session' do
          expect(subject).to receive(:reset_tribunal_case_session)
          get method
        end

        it 'redirects to the home page' do
          get method
          expect(subject).to redirect_to(root_path)
        end
      end

      context 'when survey param is provided' do
        context 'for a `true` value' do
          it 'resets the session' do
            expect(subject).to receive(:reset_session)
            get method, params: {survey: true}
          end

          it 'redirects to the survey page' do
            get method, params: {survey: true}
            expect(response.location).to match(/goo\.gl\/forms/)
          end
        end

        context 'for a `false` value' do
          it 'resets the tribunal case session' do
            expect(subject).to receive(:reset_tribunal_case_session)
            get method, params: {survey: false}
          end

          it 'redirects to the home page' do
            get method, params: {survey: false}
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
  end

  include_examples 'logs out and redirects to survey', method: :destroy
  include_examples 'logs out and redirects to survey', method: :show

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
