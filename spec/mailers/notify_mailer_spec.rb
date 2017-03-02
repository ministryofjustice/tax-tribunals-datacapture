require 'spec_helper'

RSpec.describe NotifyMailer, type: :mailer do
  describe 'taxpayer_case_confirmation' do
    let(:tribunal_case) {
      instance_double(
        TribunalCase,
        taxpayer_contact_email: 'test@example.com',
        taxpayer_individual_first_name: 'John',
        taxpayer_individual_last_name: 'Test'
      )
    }
    let(:mail) { described_class.taxpayer_case_confirmation(tribunal_case) }

    it_behaves_like 'a Notify mail', template_id: 'e64e9db9-d344-4041-a7df-135fbd39fa56',
                                     recipient: 'test@example.com'

    it 'sets the personalisation' do
      expect(mail.govuk_notify_personalisation.keys.sort).to eq([:first_name, :last_name])
    end
  end

  describe 'ftt_new_case_notification' do
    let(:tribunal_case) { instance_double(TribunalCase) }
    let(:mail) { described_class.ftt_new_case_notification(tribunal_case) }

    it_behaves_like 'a Notify mail', template_id: '50d09d1e-4e61-4ad3-9697-836b8cbb9f1f',
                                     recipient: 'jesus.laiz+ftt@digital.justice.gov.uk'
  end
end
