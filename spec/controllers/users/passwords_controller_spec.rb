require 'rails_helper'

RSpec.describe Users::PasswordsController do
  before do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe '#new' do
    it 'responds with HTTP success' do
      get :new
      expect(response).to be_successful
    end
  end

  describe '#create' do
    def do_post
      post :create, params: {'user' => {
        email: 'foo@bar.com'
      }}
    end

    it 'redirects to the confirmation path' do
      do_post
      expect(response).to redirect_to(users_reset_sent_path)
    end
  end

  describe '#update' do
    def do_update
      put :update, params: { 'user' => {
        password: 'foo@bar.com',
        password_confirmation: 'passw0rd',
        reset_password_token: 'whatever'
      }}
    end

    context 'when the parameters are valid' do
      let(:user) { User.new }

      before do
        allow(User).to receive(:reset_password_by_token).and_return(user)
      end

      it 'signs the user in and redirects to the cases portfolio' do
        do_update
        expect(response).to redirect_to(user_session_path)
      end
    end

    context 'when the parameters are not valid' do
      it 'does not sign a user in and re-renders the page' do
        do_update
        expect(response).to redirect_to(new_user_password_path)
      end
    end
  end

  describe '#reset_sent' do
    it 'renders the expected page' do
      get :reset_sent
      expect(response).to render_template(:reset_sent)
    end
  end
end
