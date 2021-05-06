require 'rails_helper'

RSpec.describe ClosureHomeController, type: :controller do
  describe '#index' do
    it 'renders the expected page' do
      local_get :index
      expect(response).to render_template(:index)
    end

    it 'should not initialise a tribunal case' do
      local_get :index
      expect(controller.current_tribunal_case).to be_nil
    end
  end
end
