require 'spec_helper'

RSpec.shared_examples 'a start step controller' do
  describe '#show' do
    it 'is successful' do
      get :show
      expect(response).to be_successful
    end
  end
end
