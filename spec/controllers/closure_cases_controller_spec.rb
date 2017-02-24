require 'rails_helper'

RSpec.describe ClosureCasesController, type: :controller do

  let(:current_tribunal_case) { instance_double(TribunalCase, case_status: nil) }
  let(:case_creator_double) { instance_double(CaseCreator, call: case_creator_result) }
  let(:case_submitted_mail_double) { double(deliver_later: true) }

  include_examples 'checks the validity of the current tribunal case on create'

  describe 'POST #create' do
    before do
      allow(subject).to receive(:current_tribunal_case).and_return(current_tribunal_case)
      allow(CaseCreator).to receive(:new).with(current_tribunal_case).and_return(case_creator_double)
      allow(NotifyMailer).to receive(:case_submitted).with(current_tribunal_case).and_return(case_submitted_mail_double)
    end

    context 'for a successful result' do
      let(:case_creator_result) { instance_double(CaseCreator, success?: true, errors: []) }

      it 'should generate and upload the case details PDF' do
        expect_any_instance_of(CaseDetailsPdf).to receive(:generate_and_upload).and_return(true)
        post :create
      end

      it 'should redirect to the confirmation page' do
        allow(controller).to receive(:generate_and_upload_pdf)
        post :create
        expect(response).to redirect_to(steps_closure_confirmation_path)
      end

      it 'should send a case submitted email' do
        allow(subject).to receive(:generate_and_upload_pdf)
        expect(case_submitted_mail_double).to receive(:deliver_later)
        post :create
      end
    end

    context 'for an unsuccessful result' do
      let(:case_creator_result) { instance_double(CaseCreator, success?: false, errors: ['an error']) }

      it 'should redirect to the summary page with an error' do
        post :create
        expect(flash[:alert]).to eq(['an error'])
        expect(response).to redirect_to(steps_closure_check_answers_path)
      end

      it 'should not send a case submitted email' do
        expect(case_submitted_mail_double).not_to receive(:deliver_later)
      end
    end
  end
end
