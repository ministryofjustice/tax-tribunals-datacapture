require 'rails_helper'

RSpec.describe HomeController do
  describe '#index' do
    it 'renders the expected page' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe '#start' do
    it 'resets the tribunal case in the session' do
      expect(subject).to receive(:reset_tribunal_case_session)
      get :start
    end

    it 'assigns the expected link sections' do
      get :start

      name, time, link = assigns[:link_sections][0]
      expect(name).to eq(:appeal)
      expect(time).to eq(30)
      expect(link).to eq('/appeal')

      name, time, link = assigns[:link_sections][1]
      expect(name).to eq(:close)
      expect(time).to eq(15)
      expect(link).to eq('/closure')

      name, time, link = assigns[:link_sections][2]
      expect(name).to eq(:home_login)
      expect(time).to eq(0)
      expect(link).to eq('/users/login')
    end

    context 'when user is logged in' do
      let(:user) { instance_double(User) }

      before do
        sign_in(user)
      end

      it 'the link to login points to the cases portfolio' do
        get :start

        name, time, link = assigns[:link_sections][2]
        expect(name).to eq(:home_login)
        expect(time).to eq(0)
        expect(link).to eq('/users/cases')
      end
    end
  end

  describe '#contact' do
    it 'renders the expected page' do
      get :contact
      expect(response).to render_template(:contact)
    end
  end

  describe '#terms_and_conditions' do
    it 'renders the expected page' do
      get :terms_and_conditions
      expect(response).to render_template(:terms_and_conditions)
    end
  end
end
