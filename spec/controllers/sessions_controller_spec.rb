require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe '#destroy' do
    it 'resets the session' do
      get :destroy, session: { foo: 'BAR' }
      expect(session).to be_empty
    end

    it 'redirects to the start page' do
      get :destroy
      expect(subject).to redirect_to(task_list_path)
    end
  end

  [
    'create_and_fill_cost',
    'create_and_fill_cost_and_lateness',
    'create_and_fill_cost_and_lateness_and_appellant'
  ].each do |method|
    describe "##{method}" do
      before do
        expect(Rails.env).to receive(:development?).at_least(:once).and_return(false)
      end

      it 'will not work in a non-development environment' do
        expect { post method.to_sym }.to raise_error(RuntimeError)
      end
    end
  end

end
