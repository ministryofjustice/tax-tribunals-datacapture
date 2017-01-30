require 'rails_helper'

RSpec.describe HomeController do
  describe '#index' do
    before do
      expect(ENV).to receive(:fetch).with('FEES_EXTERNAL_URL').and_return('http://payments.url')
    end

    it 'assigns the expected link sections' do
      get :index

      name, time, link = assigns[:link_sections][0]
      expect(name).to eq(:appeal)
      expect(time).to eq(30)
      expect(link).to eq('/task_list')

      name, time, link = assigns[:link_sections][1]
      expect(name).to eq(:close)
      expect(time).to eq(15)
      expect(link).to eq('/steps/closure/start')

      name, time, link = assigns[:link_sections][2]
      expect(name).to eq(:pay)
      expect(time).to eq(5)
      expect(link).to eq('http://payments.url')
    end
  end
end
