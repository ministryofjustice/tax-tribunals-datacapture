require 'rails_helper'

RSpec.describe Steps::Details::EuExitController, type: :controller do
  describe '#edit' do
    let!(:existing_case) { TribunalCase.create }
    before { get :edit, session: { tribunal_case_id: existing_case.id } }

    it { expect(response).to be_successful }
    it { expect(assigns(:form_object)).to be_a_kind_of(Steps::Details::EuExitForm) }
  end

  describe '#update' do
    let(:form_object) { instance_double(Steps::Details::EuExitForm, attributes: { foo: double }) }
    let(:expected_params) { { 'steps_details_eu_exit_form' => { foo: 'bar' } } }

    context 'when there is no case in the session' do
      before do
        allow(controller).to receive(:current_tribunal_case).and_return(nil)
      end

      it 'redirects to the invalid session error page' do
        put :update, params: expected_params
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end

    context 'when there is an already submitted case in the session' do
      let(:existing_case) { TribunalCase.create(case_status: CaseStatus::SUBMITTED) }

      before do
        allow(controller).to receive(:current_tribunal_case).and_call_original
      end

      it 'redirects to the case already submitted error page' do
        put :update, params: expected_params, session: { tribunal_case_id: existing_case.id }
        expect(response).to redirect_to(case_submitted_errors_path)
      end
    end

    context 'when a case in progress is in the session' do
      let(:existing_case) { TribunalCase.create(case_status: nil) }
      let(:form_object) { instance_double(Steps::Details::EuExitForm, attributes: { eu_exit: true }) }

      before do
        expect(controller).to receive(:store_step_path_in_session)
        allow(Steps::Details::EuExitForm).to receive(:new).and_return(form_object)
      end

      context 'when the form saves successfully' do
        let(:expected_params) { { 'steps_details_eu_exit_form' => { 'eu_exit': 'true' } } }

        it 'redirects to the outcome page' do
          allow(form_object).to receive(:save).and_return true
          put :update, params: expected_params, session: { tribunal_case_id: existing_case.id }
          expect(response).to redirect_to(edit_steps_details_outcome_path)
        end

      end

      context 'when no option is selected and the form is submitted' do
        let(:expected_params) { { 'steps_details_eu_exit_form' => { 'eu_exit': nil } } }

        it 'redirects to the outcome page' do
          allow(form_object).to receive(:save).and_return true
          put :update, params: expected_params, session: { tribunal_case_id: existing_case.id }
          expect(response).to redirect_to(edit_steps_details_outcome_path)
        end

      end
    end
  end
end