require 'rails_helper'

RSpec.describe Users::LoginsController do
  let(:tribunal_case) { nil }

  before do
    allow(subject).to receive(:current_tribunal_case).and_return(tribunal_case)
  end

  describe '#new' do
    it 'responds with HTTP success' do
      get :new
      expect(response).to be_successful
    end
  end

  describe '#create' do
    let(:form_object) { double('form object', save: saved, user: user) }
    let(:user) { User.new }

    before do
      expect(Users::LoginForm).to receive(:new).with(
        tribunal_case: tribunal_case,
        email: 'foo@bar.com',
        password: 'passw0rd'
      ).and_return(form_object)
    end

    context 'when the form object saves successfully' do
      let(:saved) { true }

      it 'signs the user in and redirects to the email confirmation' do
        expect(subject).to receive(:sign_in).with(user).and_return(true)

        post :create, params: { 'users_login_form' => {
          email: 'foo@bar.com',
          password: 'passw0rd'
        }}

        expect(response).to redirect_to(users_cases_path)
      end
    end

    context 'when the form object does not save' do
      let(:saved) { false }

      it 'does not sign a user in and re-renders the page' do
        expect(subject).to_not receive(:sign_in)

        post :create, params: { 'users_login_form' => {
          email: 'foo@bar.com',
          password: 'passw0rd'
        }}

        expect(subject).to render_template(:new)
      end
    end
  end
end
