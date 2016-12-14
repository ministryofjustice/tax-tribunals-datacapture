require 'rails_helper'

RSpec.describe GlimrCasesController, type: :controller do

  let(:current_tribunal_case) { instance_double(TribunalCase) }
  let(:case_creator_double) { instance_double(CaseCreator, call: call_result, errors: errors, payment_url: 'http://www.example.com') }

  let(:call_result) { true }
  let(:errors) { nil }

  describe 'POST #create' do
    before do
      allow(subject).to receive(:current_tribunal_case).and_return(current_tribunal_case)
      allow(CaseCreator).to receive(:new).and_return(case_creator_double)
    end

    context 'for a successful result' do
      it 'should redirect to the payment page' do
        post :create
        expect(response).to have_http_status(:redirect)
      end
    end

    context 'for an unsuccessful result' do
      let(:call_result) { false }
      let(:errors) { ['an error'] }

      it 'should redirect to the summary page with an error' do
        post :create
        expect(flash[:alert]).to eq(errors)
        expect(response).to redirect_to(steps_details_start_url)
      end
    end
  end
end
