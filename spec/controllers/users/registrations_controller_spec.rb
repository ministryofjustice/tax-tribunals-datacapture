require 'rails_helper'

RSpec.describe Users::RegistrationsController do
  before do
    allow(subject).to receive(:current_tribunal_case).and_return(tribunal_case)
  end

  describe '#new' do
    context 'when there is no tribunal case in the session' do
      let(:tribunal_case) { nil }

      it 'redirects to case not found error' do
        get :new
        expect(response).to redirect_to(case_not_found_errors_path)
      end
    end

    context 'when there is a case in the session' do
      let(:tribunal_case) { instance_double(TribunalCase) }

      it 'responds with HTTP success' do
        get :new
        expect(response).to be_successful
      end
    end
  end

  describe '#create' do
    context 'when there is no tribunal case in the session' do
      let(:tribunal_case) { nil }

      it 'redirects to case not found error' do
        post :create, params: { doesnt: 'matter' }
        expect(response).to redirect_to(case_not_found_errors_path)
      end
    end

    context 'when there is a case in the session' do
      let(:tribunal_case) { instance_double(TribunalCase) }
      let(:form_object) { double('form object', save: saved, user: user) }
      let(:user) { User.new }

      before do
        expect(Users::RegistrationForm).to receive(:new).with(
          tribunal_case: tribunal_case,
          email: 'foo@bar.com',
          password: 'passw0rd',
          user_case_reference: 'FOO'
        ).and_return(form_object)

      end

      context 'when the form object saves successfully' do
        let(:saved) { true }

        it 'signs the user in and redirects to the email confirmation' do
          expect(subject).to receive(:sign_in).with(user).and_return(true)

          post :create, params: { 'users_registration_form' => {
            'email' => 'foo@bar.com',
            'password' => 'passw0rd',
            'user_case_reference' => 'FOO'
          } }

          expect(response).to redirect_to(edit_users_email_confirmation_path)
        end
      end

      context 'when the form object does not save successfully' do
        let(:saved) { false }

        it 're-renders the form' do
          post :create, params: { 'users_registration_form' => {
            'email' => 'foo@bar.com',
            'password' => 'passw0rd',
            'user_case_reference' => 'FOO'
          } }

          expect(subject).to render_template(:new)
        end
      end
    end
  end
end
