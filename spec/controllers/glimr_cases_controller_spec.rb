require 'rails_helper'

RSpec.describe GlimrCasesController, type: :controller do

  let(:current_tribunal_case) { instance_double(TribunalCase) }
  let(:case_creator_double) { instance_double(CaseCreator, call: case_creator_result) }

  describe 'POST #create' do
    before do
      allow(subject).to receive(:current_tribunal_case).and_return(current_tribunal_case)
      allow(CaseCreator).to receive(:new).with(current_tribunal_case).and_return(case_creator_double)
    end

    context 'for a successful result' do
      let(:case_creator_result) { instance_double(CaseCreator, success?: true, errors: [], payment_url: 'http://www.example.com') }

      it 'should redirect to the payment page' do
        post :create
        expect(response).to have_http_status(:redirect)
      end
    end

    context 'for an unsuccessful result' do
      let(:case_creator_result) { instance_double(CaseCreator, success?: false, errors: ['an error']) }

      it 'should redirect to the summary page with an error' do
        post :create
        expect(flash[:alert]).to eq(['an error'])
        expect(response).to redirect_to(steps_details_start_url)
      end
    end
  end
end
