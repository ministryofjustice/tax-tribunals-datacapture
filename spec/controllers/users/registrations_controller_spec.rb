require 'rails_helper'

RSpec.describe Users::RegistrationsController do
  let(:tribunal_case) { double.as_null_object }

  before do
    allow(subject).to receive(:current_tribunal_case).and_return(tribunal_case)
    request.env['devise.mapping'] = Devise.mappings[:user]
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
      def do_post
        post :create, params: { 'user' => {
            'email' => 'foo@bar.com',
            'password' => 'passw0rd'
        } }
      end

      context 'when the registration was successful' do
        before do
          expect(NotifyMailer).to receive(:new_account_confirmation).with(tribunal_case).and_return(double.as_null_object)
        end

        it 'creates the user and redirects to the confirmation page' do
          expect { do_post }.to change{ User.count }.by(1)
          expect(response).to redirect_to(users_signup_save_confirmation_path)
        end

        it 'links the current tribunal case to the user' do
          expect(tribunal_case).to receive(:update).with(user: an_instance_of(User))
          do_post
        end

        it 'it stores the signed up email address in the session' do
          do_post
          expect(session[:signed_up_user_email]).to eq('foo@bar.com')
        end
      end

      context 'when the registration was unsuccessful' do
        it 'does not create the user and re-renders the page' do
          post :create, params: { 'user' => {
              'email' => 'foo@bar.com',
              'password' => 'short'
          } }
          expect(tribunal_case).not_to have_received(:update)
          expect(subject).to render_template(:new)
        end
      end
    end
  end

  describe '#signup_save_confirmation' do
    it 'renders the expected page' do
      get :signup_save_confirmation
      expect(response).to render_template(:signup_save_confirmation)
    end
  end
end
