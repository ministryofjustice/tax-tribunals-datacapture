require 'spec_helper'

RSpec.describe NotifyMailer, type: :mailer do
  describe 'taxpayer_case_confirmation' do
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

    let(:mail) { described_class.taxpayer_case_confirmation(tribunal_case) }

    it_behaves_like 'a Notify mail', template_id: 'e64e9db9-d344-4041-a7df-135fbd39fa56'

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
    let(:tribunal_case) { instance_double(TribunalCase) }
    let(:mail) { described_class.ftt_new_case_notification(tribunal_case) }

    it_behaves_like 'a Notify mail', template_id: '50d09d1e-4e61-4ad3-9697-836b8cbb9f1f'

    it 'sets the right recipient' do
      expect(mail.to).to eq(['jesus.laiz+ftt@digital.justice.gov.uk'])
    end
  end
end
