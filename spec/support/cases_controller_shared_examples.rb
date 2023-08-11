require 'rails_helper'

RSpec.shared_examples 'submits the tribunal case to GLiMR' do |options|
  let(:confirmation_path) { options.fetch(:confirmation_path) }

  let(:current_tribunal_case) { instance_double(TribunalCase,
    case_status: nil,
    case_reference: case_reference,
    send_taxpayer_copy?: send_taxpayer_copy,
    send_taxpayer_text_copy?: false,
    send_representative_copy?: send_representative_copy,
    send_representative_text_copy?: false) }
  let(:case_creator_double) { instance_double(TaxTribs::CaseCreator, call: true) }
  let(:taxpayer_case_confirmation_mail_double) { double(deliver_later: true) }
  let(:ftt_new_case_notification_mail_double) { double(deliver_later: true) }
  let(:case_reference) { nil }
  let(:send_taxpayer_copy) { false }
  let(:send_representative_copy) { false }
  let(:mail_double) { double(deliver_later: true) }

  describe 'POST #create' do
    before do
      allow(subject).to receive(:current_tribunal_case).and_return(current_tribunal_case)
      allow(subject).to receive(:generate_and_upload_pdf)

      allow(TaxTribs::CaseCreator).to receive(:new).with(current_tribunal_case).and_return(case_creator_double)

      allow(NotifyMailer).to receive(:taxpayer_case_confirmation).with(current_tribunal_case).and_return(taxpayer_case_confirmation_mail_double)
      allow(NotifyMailer).to receive(:ftt_new_case_notification).with(current_tribunal_case).and_return(ftt_new_case_notification_mail_double)
    end

    context 'for a successful result, where we have a case reference' do
      let(:case_reference) { 'XXX' }

      it 'should generate and upload the case details PDF' do
        allow(subject).to receive(:generate_and_upload_pdf).and_call_original
        expect_any_instance_of(TaxTribs::CaseDetailsPdf).to receive(:generate_and_upload).and_return(true)
        local_post :create
      end

      it 'should send a case submitted email' do
        expect(taxpayer_case_confirmation_mail_double).to receive(:deliver_later)
        local_post :create
      end

      it 'should redirect to the confirmation page' do
        local_post :create
        expect(response).to redirect_to(confirmation_path)
      end
    end

    context 'for an unsuccessful result, where we do not have a case reference' do
      let(:case_reference) { nil }

      it 'should generate and upload the case details PDF' do
        allow(subject).to receive(:generate_and_upload_pdf).and_call_original
        expect_any_instance_of(TaxTribs::CaseDetailsPdf).to receive(:generate_and_upload).and_return(true)
        local_post :create
      end

      it 'should send a `case submitted` email' do
        expect(taxpayer_case_confirmation_mail_double).to receive(:deliver_later)
        local_post :create
      end

      it 'should send a `case with errors` email' do
        expect(ftt_new_case_notification_mail_double).to receive(:deliver_later)
        local_post :create
      end

      it 'should redirect to the confirmation page' do
        local_post :create
        expect(response).to redirect_to(confirmation_path)
      end
    end

    context 'send application details copy to taxpayer' do
      let(:send_taxpayer_copy) { true }

      it 'should send email' do
        allow(subject).to receive(:case_to_string).and_return('string content')
        expect(NotifyMailer).to receive(:application_details_copy)
          .with(current_tribunal_case, :taxpayer, 'string content')
          .and_return(mail_double)

        local_post :create
      end

      it 'should render email content' do
        allow(NotifyMailer).to receive(:application_details_copy).and_return(mail_double)
        expect(subject).to receive(:render_to_string)
          .with(template: subject.pdf_template, formats: [:text], encoding: 'UTF-8')

        local_post :create
      end
    end

    context 'send application details copy to representative' do
      let(:send_representative_copy) { true }

      it 'should send email' do
        allow(subject).to receive(:case_to_string).and_return('string content')
        expect(NotifyMailer).to receive(:application_details_copy)
          .with(current_tribunal_case, :representative, 'string content')
          .and_return(mail_double)

        local_post :create
      end
    end
  end
end
