require 'rails_helper'

RSpec.shared_examples 'a password-protected admin controller' do
  context 'missing credentials' do
    it 'requires basic auth' do
      local_get :index
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'wrong credentials' do
    before do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('admin', 'whatever')
    end

    it 'returns http unauthorized' do
      local_get :index
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

RSpec.shared_examples 'a password-protected admin controller (#new)' do
  context 'missing credentials' do
    it 'requires basic auth' do
      local_get :new
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'wrong credentials' do
    before do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('admin', 'whatever')
    end

    it 'returns http unauthorized' do
      local_get :new
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

RSpec.shared_examples 'a password-protected admin controller (#create)' do
  context 'missing credentials' do
    it 'requires basic auth' do
      local_get :create
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'wrong credentials' do
    before do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('admin', 'whatever')
    end

    it 'returns http unauthorized' do
      local_get :create
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
