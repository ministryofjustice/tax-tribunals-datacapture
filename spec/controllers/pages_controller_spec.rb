require 'rails_helper'

RSpec.describe PagesController do
  describe '#contact' do
    it 'renders the expected page' do
      get :contact
      expect(response).to render_template(:contact)
    end
  end
end
