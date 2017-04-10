require 'rails_helper'

RSpec.describe CasesController, type: :controller do
  describe '#destroy' do
    let!(:tribunal_case) { TribunalCase.create }

    it 'deletes the tribunal case by ID' do
      expect {
        delete :destroy, params: { id: tribunal_case.id }
      }.to change { TribunalCase.count }.by(-1)
    end

    it 'redirects to the cases portfolio' do
      delete :destroy, params: { id: tribunal_case.id }
      expect(response).to redirect_to(saved_appeals_path)
    end

    it 'raises an exception if case is not found' do
      expect {
        delete :destroy, params: { id: '123' }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
