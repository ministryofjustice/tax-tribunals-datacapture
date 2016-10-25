require 'rails_helper'

RSpec.describe Steps::DidChallengeHmrcController, type: :controller do
  describe 'GET /edit' do
    context 'when no case exists in the session yet' do
      it 'creates a case and shows the question to the user' do
        get :edit

        expect(response).to have_http_status(:success)
        expect(TribunalCase.count).to be(1)
        expect(session[:tribunal_case_id]).to eq(TribunalCase.first.id)
      end
    end

    context 'when a case exists in the session' do
      it 'uses the existing case and shows the question to the user' do
        existing_case = TribunalCase.create
        get :edit, session: { tribunal_case_id: existing_case.id }

        expect(response).to have_http_status(:success)
        expect(TribunalCase.count).to be(1)
        expect(session[:tribunal_case_id]).to eq(TribunalCase.first.id)
      end
    end
  end
end
