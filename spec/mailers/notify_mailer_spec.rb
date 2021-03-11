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
  let(:report_form) {
    double(
      name: 'Jane Doe',
      email: 'jane@example.com',
      assistance_level: 'none',
      comment: 'Some text'
    )
  }

  before do
    allow(ENV).to receive(:fetch).with('NOTIFY_CASE_CONFIRMATION_TEMPLATE_ID').and_return('confirmation-template')
    allow(ENV).to receive(:fetch).with('NOTIFY_FTT_CASE_NOTIFICATION_TEMPLATE_ID').and_return('ftt-notification-template')
    allow(ENV).to receive(:fetch).with('NOTIFY_RESET_PASSWORD_TEMPLATE_ID').and_return('reset-password-template')
    allow(ENV).to receive(:fetch).with('NOTIFY_CHANGE_PASSWORD_TEMPLATE_ID').and_return('change-password-template')
    allow(ENV).to receive(:fetch).with('NOTIFY_NEW_CASE_SAVED_TEMPLATE_ID').and_return('new-case-saved-template')
    allow(ENV).to receive(:fetch).with('NOTIFY_STATISTICS_REPORT_TEMPLATE_ID').and_return('statistics-report')
    allow(ENV).to receive(:fetch).with('NOTIFY_REPORT_PROBLEM_TEMPLATE_ID').and_return('report-problem-template')
    allow(ENV).to receive(:fetch).with('NOTIFY_SEND_APPLICATION_DETAIL_TEMPLATE_ID').and_return('application-details-template')
  end

  describe '#report_problem' do
    before do
      allow(ENV).to receive(:fetch).with('REPORT_PROBLEM_EMAIL_ADDRESS').and_return('reporting@example.com')
    end

    let(:mail) { described_class.report_problem(report_form) }
    it_behaves_like 'a Notify mail', template_id: 'report-problem-template'

    it 'has the right keys' do
      expect(mail.govuk_notify_personalisation.keys).to eq([:name, :email, :assistance_level, :comment])
    end

    it "gets the template id from an env var" do
      expect(ENV).to receive(:fetch).with('NOTIFY_REPORT_PROBLEM_TEMPLATE_ID')
      mail.body
    end

    it "gets the recipient from an env var" do
      expect(ENV).to receive(:fetch).with('REPORT_PROBLEM_EMAIL_ADDRESS')
      mail.body
    end
  end

  describe '#statistics_report' do
    before do
      allow(ENV).to receive(:fetch).with('STATISTICS_REPORT_EMAIL_ADDRESS').and_return('reporting@tax-tribunals.org')
    end

    let(:mail) { described_class.statistics_report('My Title', "foo\nbar\nbaz") }
    it_behaves_like 'a Notify mail', template_id: 'statistics-report'

    it 'has the right keys' do
      expect(mail.govuk_notify_personalisation).to eq({
        title: 'My Title',
        data: "foo\nbar\nbaz"
      })
    end

    it "gets the template id from an env var" do
      expect(ENV).to receive(:fetch).with('NOTIFY_STATISTICS_REPORT_TEMPLATE_ID')
      mail.body
    end

    it "gets the recipient from an env var" do
      expect(ENV).to receive(:fetch).with('STATISTICS_REPORT_EMAIL_ADDRESS')
      mail.body
    end
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
        draft_expire_in_days: 14,
        show_deadline_warning: 'yes',
        resume_case_link: "https://tax.justice.uk/#{I18n.locale}/users/cases/4a362e1c-48eb-40e3-9458-a31ead3f30a4/resume"
      })
    end

    it "gets the template id from an env var" do
      expect(ENV).to receive(:fetch).with('NOTIFY_NEW_CASE_SAVED_TEMPLATE_ID')
      mail.body
    end
  end

  describe '#reset_password_instructions' do
    let(:mail) { described_class.reset_password_instructions(user, token) }
    let(:user) { User.new(email: 'shirley.schmidt@cranepooleandschmidt.com') }
    let(:token) { '0xDEADBEEF' }

    it_behaves_like 'a Notify mail', template_id: 'reset-password-template'

    it 'has the right keys' do
      expect(mail.govuk_notify_personalisation).to eq({
        reset_url: "https://tax.justice.uk/#{I18n.locale}/users/password/edit?reset_password_token=0xDEADBEEF"
      })
    end

    it "gets the template id from an env var" do
      expect(ENV).to receive(:fetch).with('NOTIFY_RESET_PASSWORD_TEMPLATE_ID')
      mail.body
    end
  end

  describe '#password_change' do
    let(:mail) { described_class.password_change(user) }
    let(:user) { User.new(email: 'shirley.schmidt@cranepooleandschmidt.com') }

    it_behaves_like 'a Notify mail', template_id: 'change-password-template'

    it 'has the right keys' do
      expect(mail.govuk_notify_personalisation).to eq({
        portfolio_url: "https://tax.justice.uk/#{I18n.locale}/users/cases"
      })
    end

    it "gets the template id from an env var" do
      expect(ENV).to receive(:fetch).with('NOTIFY_CHANGE_PASSWORD_TEMPLATE_ID')
      mail.body
    end
  end

  describe 'taxpayer_case_confirmation' do
    let(:mail) { described_class.taxpayer_case_confirmation(tribunal_case) }

    it_behaves_like 'a Notify mail', template_id: 'confirmation-template'

    it "gets the template id from an env var" do
      expect(ENV).to receive(:fetch).with('NOTIFY_CASE_CONFIRMATION_TEMPLATE_ID')
      mail.body
    end

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
        expect(Sentry).to receive(:capture_exception)
        expect(Sentry).to receive(:set_extras).with(
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

    it "gets the template id from an env var" do
      expect(ENV).to receive(:fetch).with('NOTIFY_FTT_CASE_NOTIFICATION_TEMPLATE_ID')
      mail.body
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
        ).to eq([:appeal_or_application, :show_deadline_warning, :resume_case_link])
      end
    end
  end

  describe 'personalisation logging filter' do
    let(:filter) { described_class::PERSONALISATION_ERROR_FILTER }
    it { expect(filter).to match_array([:recipient_name, :company_name, :documents_url, :reset_url]) }
  end

  describe 'application_details_copy' do
    let(:mail) { described_class.application_details_copy(tribunal_case, :taxpayer, "email content") }

    before do
      expect(tribunal_case).to receive(:send)
        .with(:taxpayer_contact_email)
        .and_return('taxpayer@email.com')
    end

    it_behaves_like 'a Notify mail', template_id: 'application-details-template'

    context 'recipient' do
      it { expect(mail.to).to eq(['taxpayer@email.com']) }
    end

    context 'personalisation' do
      it 'sets the personalisation' do
        expect(
          mail.govuk_notify_personalisation.keys
        ).to eq([:appeal_or_application, :application_details])
      end

      it 'uses provided email content' do
        expect(mail.govuk_notify_personalisation[:application_details]).to eq("email content")
      end
    end

    it "gets the template id from an env var" do
      expect(ENV).to receive(:fetch).with('NOTIFY_SEND_APPLICATION_DETAIL_TEMPLATE_ID')
      mail.body
    end
  end
end
