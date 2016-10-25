require 'rails_helper'

RSpec.describe Steps::DidChallengeHmrcController, type: :controller do
  describe 'GET /edit' do
    context 'when no case exists in the session yet' do
      it 'creates a new case' do
        expect { get :edit }.to change { TribunalCase.count }.by(1)
      end

      it 'responds with HTTP success' do
        get :edit
        expect(response).to be_successful
      end

      it 'sets the case ID in the session' do
        get :edit
        expect(session[:tribunal_case_id]).to eq(TribunalCase.first.id)
      end
    end

    context 'when a case exists in the session' do
      let!(:existing_case) { TribunalCase.create }

      it 'does not create a new case' do
        expect {
          get :edit, session: { tribunal_case_id: existing_case.id }
        }.to_not change { TribunalCase.count }
      end

      it 'responds with HTTP success' do
        get :edit, session: { tribunal_case_id: existing_case.id }
        expect(response).to be_successful
      end

      it 'does not change the case ID in the session' do
        get :edit, session: { tribunal_case_id: existing_case.id }
        expect(session[:tribunal_case_id]).to eq(existing_case.id)
      end
    end
  end
end
