require 'rails_helper'

RSpec.describe Users::EmailConfirmationsController do
  before do
    allow(subject).to receive(:current_user).and_return(user)
  end

  describe '#edit' do
    context 'when there is no user in the session' do
      let(:user) { nil }

      it 'redirects to case not found error' do
        get :edit
        expect(response).to redirect_to(case_not_found_errors_path)
      end
    end

    context 'when there is a user in the session' do
      let(:user) { instance_double(User) }

      it 'responds with HTTP success' do
        get :edit
        expect(response).to be_successful
      end
    end
  end

  describe '#update' do
    context 'when there is no user in the session' do
      let(:user) { nil }

      it 'redirects to case not found error' do
        post :update, params: { doesnt: 'matter' }
        expect(response).to redirect_to(case_not_found_errors_path)
      end
    end

    context 'when there is a user in the session' do
      let(:user) { instance_double(User) }
      let(:form_object) { double('form object', save: saved) }

      before do
        expect(Users::EmailConfirmationForm).to receive(:new).with(
          user: user,
          email: 'foo@bar.com',
          email_correct: 'yes'
        ).and_return(form_object)

        post :update, params: { 'users_email_confirmation_form' => {
          'email' => 'foo@bar.com',
          'email_correct' => 'yes'
        } }
      end

      context 'when the form object saves successfully' do
        let(:saved) { true }

        it 'redirects to the appeal saved path' do
          expect(response).to redirect_to(appeal_saved_path)
        end
      end

      context 'when the form object does not save successfully' do
        let(:saved) { false }

        it 're-renders the form' do
          expect(subject).to render_template(:edit)
        end
      end
    end
  end
end
