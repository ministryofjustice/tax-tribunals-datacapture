require 'rails_helper'

RSpec.describe Steps::Hardship::HardshipContactHmrcController, type: :controller do
  let(:existing_case) { TribunalCase.create(case_status: nil) }

  before do
    allow(controller).to receive(:current_tribunal_case).and_return(existing_case)
  end

  describe '#edit' do
    it 'renders the expected page' do
      local_get :edit
      expect(response).to render_template(:edit)
    end
  end

  describe '#update' do
    it 'destroys current case' do
      expect(existing_case).to receive(:destroy)
      put :update, params: {locale: :en}
    end

    it 'redirects to hmrc page' do
      put :update, params: {locale: :en}
      expect(controller).to redirect_to(described_class::CONTACT_HMRC_URL)
    end
  end
end
