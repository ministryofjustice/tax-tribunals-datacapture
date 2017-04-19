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
    let(:user) { User.new }

    def do_post
      post :create, params: { 'user' => {
        email: 'foo@bar.com',
        password: 'passw0rd'
      }}
    end

    context 'when the authentication was successful' do
      before do
        expect(warden).to receive(:authenticate!).and_return(user)
      end

      it 'signs the user in and redirects to the cases portfolio' do
        do_post
        expect(response).to redirect_to(users_cases_path)
      end

      it 'links the current tribunal case to the user' do
        expect(tribunal_case).to receive(:update).with(
          user: user
        ).and_return(true)

        do_post
      end
    end

    context 'when the authentication was unsuccessful' do
      before do
        expect(warden).to receive(:authenticate!).and_call_original
      end

      it 'does not sign a user in and re-renders the page' do
        do_post
        expect(subject).to render_template(:new)
      end
    end
  end
end
