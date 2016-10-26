require 'rails_helper'

RSpec.describe Steps::DetermineCostController, type: :controller do
  describe '#show' do
    context 'when no case exists in the session' do
      it 'raises an error' do
        expect { get :show }.to raise_error(RuntimeError)
      end
    end

    context 'when a case is in progress' do
      let(:tribunal_case) { TribunalCase.create }

      it 'is successful' do
        get :show, session: { tribunal_case_id: tribunal_case.id }
        expect(response).to be_successful
      end
    end
  end
end
