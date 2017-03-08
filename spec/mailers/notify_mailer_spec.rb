require 'spec_helper'

RSpec.describe NotifyMailer, type: :mailer do
  let(:tribunal_case) { TribunalCase.new(tribunal_case_attributes) }
  let(:tribunal_case_attributes) {
    {
      intent: intent,
      user_type: user_type,
      taxpayer_type: taxpayer_type,
      representative_type: representative_type,
      case_reference: case_reference,
      taxpayer_contact_email: 'taxpayer@example.com',
      taxpayer_individual_first_name: 'John',
      taxpayer_individual_last_name: 'Harrison'
    }
  }
  let(:intent) { Intent::TAX_APPEAL }
  let(:user_type) { UserType::TAXPAYER }
  let(:taxpayer_type) { ContactableEntityType::INDIVIDUAL }
  let(:representative_type) { ContactableEntityType::INDIVIDUAL }
  let(:case_reference) { 'TC/2017/00001' }

  before do
    allow(ENV).to receive(:fetch).with('NOTIFY_CASE_CONFIRMATION_TEMPLATE_ID').and_return('confirmation-template')
    allow(ENV).to receive(:fetch).with('NOTIFY_FTT_CASE_NOTIFICATION_TEMPLATE_ID').and_return('ftt-notification-template')
  end

  describe 'taxpayer_case_confirmation' do
    let(:mail) { described_class.taxpayer_case_confirmation(tribunal_case) }

    it_behaves_like 'a Notify mail', template_id: 'confirmation-template'

    context 'personalisation' do
      it 'sets the personalisation' do
        expect(
          mail.govuk_notify_personalisation.keys
        ).to eq([:recipient_name, :case_reference, :show_case_reference, :appeal_or_application])
      end
    end

    context 'without case reference' do
      let(:case_reference) { nil }

      it 'sets the personalisation' do
        expect(mail.govuk_notify_personalisation).to include(case_reference: '', show_case_reference: 'no')
      end
    end
  end

  describe 'ftt_new_case_notification' do
    let(:mail) { described_class.ftt_new_case_notification(tribunal_case) }

    before do
      expect(tribunal_case).to receive(:documents_url)
      allow(ENV).to receive(:fetch).with('TAX_TRIBUNAL_EMAIL').and_return('ftt@email.com')
    end

    it_behaves_like 'a Notify mail', template_id: 'ftt-notification-template'

    context 'recipient' do
      it { expect(mail.to).to eq(['ftt@email.com']) }
    end

    context 'personalisation' do
      it 'sets the personalisation' do
        expect(
          mail.govuk_notify_personalisation.keys
        ).to eq([:recipient_name, :company_name, :show_company_name, :documents_url])
      end
    end
  end
end
