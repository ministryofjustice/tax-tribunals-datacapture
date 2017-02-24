require 'spec_helper'

RSpec.describe NotifyMailer, type: :mailer do
  describe 'case_submitted' do
    let(:tribunal_case) {
      instance_double(
        TribunalCase,
        taxpayer_contact_email: 'test@example.com',
        taxpayer_individual_first_name: 'John',
        taxpayer_individual_last_name: 'Test'
      )
    }

    let(:template) { 'e64e9db9-d344-4041-a7df-135fbd39fa56' }
    let(:mail) { described_class.case_submitted(tribunal_case) }

    it 'is a govuk_notify delivery' do
      expect(mail.delivery_method).to be_a(GovukNotifyRails::Delivery)
    end

    it 'sets the recipient' do
      expect(mail.to).to eq(['test@example.com'])
    end

    # This is just internal, as the real subject gets set in the template at Notify website
    it 'sets the subject' do
      expect(mail.body).to match("This is a GOV.UK Notify email with template #{template}")
    end

    it 'sets the template' do
      expect(mail.govuk_notify_template).to eq(template)
    end

    it 'sets the personalisation' do
      expect(mail.govuk_notify_personalisation.keys.sort).to eq([:first_name, :last_name])
    end
  end
end
