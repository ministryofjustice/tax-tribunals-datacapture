require 'rails_helper'

RSpec.describe Steps::SaveAndReturnController do

  describe 'edit' do
    let!(:existing_case) { TribunalCase.create }
    before { get :edit, session: { tribunal_case_id: existing_case.id } }

    it { expect(response).to be_successful }
    it { expect(assigns(:form_object)).to be_a_kind_of(SaveAndReturn::SaveForm) }
  end

  describe 'update' do
    context 'continue to normal step flow' do
      let!(:existing_case) { TribunalCase.create }
      subject { put :update, session: { tribunal_case_id: existing_case.id, next_step: edit_steps_challenge_decision_path } }

      it { expect(subject).to redirect_to(edit_steps_challenge_decision_path) }
    end

    context 'go to save for later form' do
      let(:params) { { save_and_return_save_form: { save_for_later: true }} }
      let!(:existing_case) { TribunalCase.create }
      subject { put :update, session: { tribunal_case_id: existing_case.id }, params: params }

      it { expect(subject).to redirect_to(new_user_registration_path) }
    end
  end

end
