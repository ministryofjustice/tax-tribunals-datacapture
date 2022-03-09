require 'rails_helper'

RSpec.describe Admin::GlimrGenerationController, type: :controller do
  before do
    allow(ENV).to receive(:fetch).with('UPLOAD_PROBLEMS_REPORT_AUTH_USER').and_return('admin')
    allow(ENV).to receive(:fetch).with('UPLOAD_PROBLEMS_REPORT_AUTH_DIGEST').and_return(
      '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08'
    )
    allow(ENV).to receive(:fetch).with('GLIMR_API_URL',
      'https://glimr-api.taxtribunals.dsd.io/Live_API/api/tdsapi').and_return(
      'http://glimr'
    )
    allow(ENV).to receive(:fetch).with('GLIMR_REGISTER_NEW_CASE_TIMEOUT_SECONDS', 32).and_return(32)    
  end

  describe '#new' do
    it_behaves_like 'a password-protected admin controller (#new)'

    context 'correct credentials' do
      before do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('admin', 'test')
      end

      it 'returns http success' do
        local_get :new
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe '#create' do
    it_behaves_like 'a password-protected admin controller (#create)'

    context 'correct credentials' do
      before do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('admin', 'test')
      end

      it 'creates a batch of jobs' do
        receive_count = 0
        allow_any_instance_of(Admin::GenerateGlimrRecordJob).to \
          receive(:perform) { receive_count += 1 }
        stub_request(:any, "http://glimr/registernewcase").to_return(body: {"abc":"def"}.to_json)

        Sidekiq::Testing.inline! do
          local_post :create, params: {
            'number-of-records': 3,
            contactFirstName: 'Joe',
            contactLastName: 'Bloggs',
            contactPreference: 'email',
            email: 'test@example.com'
          }
        end
        expect(receive_count).to eq 3
      end
    end
  end
end
