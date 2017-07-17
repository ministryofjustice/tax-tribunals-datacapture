require 'rails_helper'

RSpec.describe Admin::OtherCaseTypesReportController, type: :controller do
  before do
    allow(ENV).to receive(:fetch).with('UPLOAD_PROBLEMS_REPORT_AUTH_USER').and_return('admin')
    allow(ENV).to receive(:fetch).with('UPLOAD_PROBLEMS_REPORT_AUTH_DIGEST').and_return(
      '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08'
    )
  end

  describe '#index' do
    it 'requires basic auth' do
      get :index
      expect(response).to have_http_status(:unauthorized)
    end

    context 'wrong credentials' do
      before do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('admin', 'whatever')
      end

      it 'returns http success' do
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'correct credentials' do
      before do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('admin', 'test')
      end

      it 'returns http success' do
        get :index
        expect(response).to have_http_status(:success)
      end

      it 'retrieves the cases where case type is `other`' do
        expect(TribunalCase).to receive(:with_other_case_type).and_return(double.as_null_object)
        get :index
      end
    end
  end
end
