require 'rails_helper'

RSpec.shared_examples 'submits the tribunal case to GLiMR' do |options|
  let(:confirmation_path) { options.fetch(:confirmation_path) }

  let(:current_tribunal_case) { instance_double(TribunalCase, case_status: nil, case_reference: case_reference) }
  let(:case_creator_double) { instance_double(CaseCreator, call: true) }
  let(:taxpayer_case_confirmation_mail_double) { double(deliver_later: true) }
  let(:ftt_new_case_notification_mail_double) { double(deliver_later: true) }
  let(:case_reference) { nil }

  describe 'POST #create' do
    before do
      allow(subject).to receive(:current_tribunal_case).and_return(current_tribunal_case)
      allow(subject).to receive(:generate_and_upload_pdf)

      allow(CaseCreator).to receive(:new).with(current_tribunal_case).and_return(case_creator_double)

      allow(NotifyMailer).to receive(:taxpayer_case_confirmation).with(current_tribunal_case).and_return(taxpayer_case_confirmation_mail_double)
      allow(NotifyMailer).to receive(:ftt_new_case_notification).with(current_tribunal_case).and_return(ftt_new_case_notification_mail_double)
    end

    context 'for a successful result, where we have a case reference' do
      let(:case_reference) { 'XXX' }

      it 'should generate and upload the case details PDF' do
        allow(subject).to receive(:generate_and_upload_pdf).and_call_original
        expect_any_instance_of(CaseDetailsPdf).to receive(:generate_and_upload).and_return(true)
        post :create
      end

      it 'should send a case submitted email' do
        expect(taxpayer_case_confirmation_mail_double).to receive(:deliver_later)
        post :create
      end

      it 'should redirect to the confirmation page' do
        post :create
        expect(response).to redirect_to(confirmation_path)
      end
    end

    context 'for an unsuccessful result, where we do not have a case reference' do
      let(:case_reference) { nil }

      it 'should generate and upload the case details PDF' do
        allow(subject).to receive(:generate_and_upload_pdf).and_call_original
        expect_any_instance_of(CaseDetailsPdf).to receive(:generate_and_upload).and_return(true)
        post :create
      end

      it 'should send a `case submitted` email' do
        expect(taxpayer_case_confirmation_mail_double).to receive(:deliver_later)
        post :create
      end

      it 'should send a `case with errors` email' do
        expect(ftt_new_case_notification_mail_double).to receive(:deliver_later)
        post :create
      end

      it 'should redirect to the confirmation page' do
        post :create
        expect(response).to redirect_to(confirmation_path)
      end
    end
  end
end
