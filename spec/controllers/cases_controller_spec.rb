require 'rails_helper'

RSpec.describe CasesController, type: :controller do
  let(:user) { User.new }

  describe '#index' do
    context 'when user is logged out' do
      it 'redirects to the sign-in page' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is logged in' do
      before do
        sign_in(user)
      end

      it 'renders the cases portfolio page' do
        expect(user).to receive(:pending_tribunal_cases).and_call_original
        get :index
        expect(assigns[:tribunal_cases]).not_to be_nil
        expect(response).to render_template(:index)
      end
    end
  end

  describe '#destroy' do
    context 'when user is logged out' do
      it 'redirects to the sign-in page' do
        delete :destroy, params: { id: 'any' }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is logged in' do
      let!(:tribunal_case) { TribunalCase.create }
      let(:scoped_result) { double('result') }

      before do
        sign_in(user)
      end

      it 'raises an exception if case is not found' do
        expect {
          delete :destroy, params: {id: '123'}
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      context 'when tribunal case exists' do
        before do
          expect(user).to receive(:tribunal_cases).and_return(scoped_result)
          expect(scoped_result).to receive(:find).with(tribunal_case.id).and_return(tribunal_case)
        end

        it 'deletes the tribunal case by ID' do
          expect {
            delete :destroy, params: {id: tribunal_case.id}
          }.to change { TribunalCase.count }.by(-1)
        end

        it 'redirects to the cases portfolio' do
          delete :destroy, params: {id: tribunal_case.id}
          expect(response).to redirect_to(cases_path)
        end
      end
    end
  end

  describe '#resume' do
    context 'when user is logged out' do
      it 'redirects to the sign-in page' do
        get :resume, params: { case_id: 'any' }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is logged in' do
      let!(:tribunal_case) { TribunalCase.create(intent: intent) }

      let(:intent) { nil }
      let(:scoped_result) { double('result') }

      before do
        sign_in(user)
      end

      it 'raises an exception if case is not found' do
        expect {
          get :resume, params: {case_id: '123'}
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      context 'when tribunal case exists' do
        before do
          expect(user).to receive(:pending_tribunal_cases).and_return(scoped_result)
          expect(scoped_result).to receive(:find).with(tribunal_case.id).and_return(tribunal_case)
        end

        it 'assigns the chosen tribunal case to the current session' do
          expect(session[:tribunal_case_id]).to be_nil
          get :resume, params: {case_id: tribunal_case.id}
          expect(session[:tribunal_case_id]).to eq(tribunal_case.id)
        end

        context 'redirects to the corresponding `check your answers` page' do
          before do
            get :resume, params: {case_id: tribunal_case.id}
          end

          context 'for an appeal case' do
            let(:intent) { Intent::TAX_APPEAL }
            it { expect(response).to redirect_to(steps_details_check_answers_path) }
          end

          context 'for a closure case' do
            let(:intent) { Intent::CLOSE_ENQUIRY }
            it { expect(response).to redirect_to(steps_closure_check_answers_path) }
          end
        end
      end
    end
  end
end
