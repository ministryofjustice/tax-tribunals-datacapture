require 'rails_helper'

RSpec.describe HomeController do
  describe '#index' do
    it 'assigns the expected link sections' do
      get :index

      name, time, link = assigns[:link_sections][0]
      expect(name).to eq(:appeal)
      expect(time).to eq(30)
      expect(link).to eq('/appeal')

      name, time, link = assigns[:link_sections][1]
      expect(name).to eq(:close)
      expect(time).to eq(15)
      expect(link).to eq('/steps/closure/start')
    end
  end
end
