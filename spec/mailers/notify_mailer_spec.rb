require 'spec_helper'

RSpec.describe NotifyMailer, type: :mailer do
  let(:tribunal_case) { TribunalCase.new(tribunal_case_attributes) }
  let(:tribunal_case_attributes) {
    {
      id: '4a362e1c-48eb-40e3-9458-a31ead3f30a4',
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
    allow(ENV).to receive(:fetch).with('NOTIFY_RESET_PASSWORD_TEMPLATE_ID').and_return('reset-password-template')
    allow(ENV).to receive(:fetch).with('NOTIFY_CHANGE_PASSWORD_TEMPLATE_ID').and_return('change-password-template')
    allow(ENV).to receive(:fetch).with('NOTIFY_NEW_CASE_SAVED_TEMPLATE_ID').and_return('new-case-saved-template')
  end

  describe '#new_case_saved_confirmation' do
    let(:mail) { described_class.new_case_saved_confirmation(tribunal_case) }
    let(:user) { instance_double(User, email: 'shirley.schmidt@cranepooleandschmidt.com') }

    before do
      allow(tribunal_case).to receive(:user).and_return(user)
    end

    it_behaves_like 'a Notify mail', template_id: 'new-case-saved-template'

    it 'has the right keys' do
      expect(mail.govuk_notify_personalisation).to eq({
        appeal_or_application: :appeal,
        show_deadline_warning: 'yes',
        resume_case_link: 'https://tax.justice.uk/users/cases/4a362e1c-48eb-40e3-9458-a31ead3f30a4/resume'
      })
    end
  end

  describe '#reset_password_instructions' do
    let(:mail) { described_class.reset_password_instructions(user, token) }
    let(:user) { User.new(email: 'shirley.schmidt@cranepooleandschmidt.com') }
    let(:token) { '0xDEADBEEF' }

    it_behaves_like 'a Notify mail', template_id: 'reset-password-template'

    it 'has the right keys' do
      expect(mail.govuk_notify_personalisation).to eq({
        reset_url: 'https://tax.justice.uk/users/password/edit?reset_password_token=0xDEADBEEF'
      })
    end
  end

  describe '#password_change' do
    let(:mail) { described_class.password_change(user) }
    let(:user) { User.new(email: 'shirley.schmidt@cranepooleandschmidt.com') }

    it_behaves_like 'a Notify mail', template_id: 'change-password-template'

    it 'has the right keys' do
      expect(mail.govuk_notify_personalisation).to eq({
        portfolio_url: 'https://tax.justice.uk/users/cases'
      })
    end
  end

  describe 'taxpayer_case_confirmation' do
    let(:mail) { described_class.taxpayer_case_confirmation(tribunal_case) }

    it_behaves_like 'a Notify mail', template_id: 'confirmation-template'

    context 'personalisation' do
      it 'sets the personalisation' do
        expect(
          mail.govuk_notify_personalisation.keys
        ).to eq([:recipient_name, :case_reference, :case_reference_present, :case_reference_absent, :appeal_or_application, :survey_link])
      end
    end

    context 'without case reference' do
      let(:case_reference) { nil }

      it 'sets the personalisation' do
        expect(mail.govuk_notify_personalisation).to include(case_reference: '', case_reference_present: 'no', case_reference_absent: 'yes')
      end
    end

    context 'capturing unexpected errors' do
      before do
        allow(Rails).to receive_message_chain(:configuration, :survey_link).and_return('www.survey.com')
        allow(tribunal_case).to receive(:taxpayer_contact_email).and_raise('boom')
      end

      it 'should report the exception' do
        expect(Rails.logger).to receive(:info)
        expect(Raven).to receive(:capture_exception)
        expect(Raven).to receive(:extra_context).with(
          {
            template_id: 'confirmation-template',
            personalisation: {
              recipient_name: '[FILTERED]',
              case_reference: 'TC/2017/00001',
              case_reference_present: 'yes',
              case_reference_absent: 'no',
              appeal_or_application: :appeal,
              survey_link: 'www.survey.com'
            }
          }
        )

        mail.deliver_now
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

  describe 'incomplete_case_reminder' do
    let(:mail) { described_class.incomplete_case_reminder(tribunal_case, 'reminder-template-id') }
    let(:user) { instance_double(User, email: 'user@example.com') }

    before do
      allow(tribunal_case).to receive(:user).and_return(user)
    end

    it_behaves_like 'a Notify mail', template_id: 'reminder-template-id'

    context 'recipient' do
      it { expect(mail.to).to eq(['user@example.com']) }
    end

    context 'personalisation' do
      it 'sets the personalisation' do
        expect(
          mail.govuk_notify_personalisation.keys
        ).to eq([:appeal_or_application, :resume_case_link])
      end
    end
  end

  describe 'personalisation logging filter' do
    let(:filter) { described_class::PERSONALISATION_ERROR_FILTER }
    it { expect(filter).to match_array([:recipient_name, :company_name, :documents_url, :reset_url]) }
  end
end
