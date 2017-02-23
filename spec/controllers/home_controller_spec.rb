require 'rails_helper'

RSpec.describe HomeController do
  describe '#index' do
    it 'resets the session' do
      expect(subject).to receive(:reset_session)
      get :index
    end

    it 'assigns the expected link sections' do
      get :index

      name, time, link = assigns[:link_sections][0]
      expect(name).to eq(:appeal)
      expect(time).to eq(30)
      expect(link).to eq('/steps/appeal/start')

      name, time, link = assigns[:link_sections][1]
      expect(name).to eq(:close)
      expect(time).to eq(15)
      expect(link).to eq('/steps/closure/start')
    end
  end

  describe '#contact' do
    it 'renders the expected page' do
      get :contact
      expect(response).to render_template(:contact)
    end
  end
end
