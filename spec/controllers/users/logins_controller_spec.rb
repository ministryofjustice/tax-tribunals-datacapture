require 'rails_helper'

RSpec.describe Users::LoginsController do
  let(:tribunal_case) { double.as_null_object }

  before do
    allow(subject).to receive(:current_tribunal_case).and_return(tribunal_case)
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe '#new' do
    it 'responds with HTTP success' do
      get :new
      expect(response).to be_successful
    end
  end

  describe '#create' do
    let(:user) { User.new(email: 'foo@bar.com') }

    def do_post
      post :create, params: { 'user' => {
        email: 'foo@bar.com',
        password: 'passw0rd'
      }}
    end

    context 'when the authentication was successful' do
      let(:tribunal_case) { instance_double(TribunalCase, user: user) }

      before do
        expect(warden).to receive(:authenticate!).and_return(user)
      end

      it 'signs the user in and redirects to the confirmation page' do
        do_post
        expect(response).to redirect_to(users_login_save_confirmation_path)
      end

      context 'when the case already belongs to the user (we do not send an email)' do
        it 'does not store the signed in email address in the session' do
          do_post
          expect(session[:confirmation_email_address]).to be_nil
        end
      end

      context 'when the case is new and we are linking it to the user (we send an email)' do
        before do
          expect(TaxTribs::SaveCaseForLater).to receive(:new).with(tribunal_case, user).and_return(double(save: true, email_sent?: true))
        end

        it 'it stores the signed in email address in the session' do
          do_post
          expect(session[:confirmation_email_address]).to eq('foo@bar.com')
        end
      end
    end

    context 'when the authentication was unsuccessful' do
      before do
        expect(warden).to receive(:authenticate!).and_call_original
        expect(TaxTribs::SaveCaseForLater).not_to receive(:new)
      end

      it 'does not sign a user in and re-renders the page' do
        do_post
        expect(subject).to render_template(:new)
      end
    end
  end

  describe '#destroy' do
    it 'redirects to the logged out page' do
      delete :destroy
      expect(subject).to redirect_to(users_login_logged_out_path)
    end
  end

  describe '#logged_out' do
    it 'renders the expected page' do
      get :logged_out
      expect(response).to render_template(:logged_out)
    end
  end

  describe '#save_confirmation' do
    it 'renders the expected page' do
      get :save_confirmation
      expect(response).to render_template(:save_confirmation)
    end
  end
end
