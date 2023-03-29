require 'spec_helper'

RSpec.describe NotifyMailer, type: :mailer do
  let(:tribunal_case) { TribunalCase.new(tribunal_case_attributes) }
  let(:tribunal_case_attributes) {
    {
      id: '4a362e1c-48eb-40e3-9458-a31ead3f30a4',
      intent: intent,
      language: language,
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
  let(:language) { Language::English }
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
  let(:govuk_notify_templates) do
    {
      english: {
        new_case_saved_confirmation: 'NOTIFY_NEW_CASE_SAVED_TEMPLATE_ID',
        reset_password_instructions: 'NOTIFY_RESET_PASSWORD_TEMPLATE_ID',
        password_change: 'NOTIFY_CHANGE_PASSWORD_TEMPLATE_ID',
        taxpayer_case_confirmation: 'NOTIFY_CASE_CONFIRMATION_TEMPLATE_ID',
        ftt_new_case_notification: 'NOTIFY_FTT_CASE_NOTIFICATION_TEMPLATE_ID',
        application_details_copy: 'NOTIFY_SEND_APPLICATION_DETAIL_TEMPLATE_ID',
        application_details_text: 'NOTIFY_SEND_APPLICATION_DETAIL_TEXT_TEMPLATE_ID',
        first_reminder: 'NOTIFY_CASE_FIRST_REMINDER_TEMPLATE_ID',
        last_reminder: 'NOTIFY_CASE_LAST_REMINDER_TEMPLATE_ID'
      },
      english_welsh: {
        new_case_saved_confirmation: 'NOTIFY_NEW_CASE_SAVED_CY_TEMPLATE_ID',
        reset_password_instructions: 'NOTIFY_RESET_PASSWORD_CY_TEMPLATE_ID',
        password_change: 'NOTIFY_CHANGE_PASSWORD_CY_TEMPLATE_ID',
        taxpayer_case_confirmation: 'NOTIFY_CASE_CONFIRMATION_CY_TEMPLATE_ID',
        ftt_new_case_notification: 'NOTIFY_FTT_CASE_NOTIFICATION_CY_TEMPLATE_ID',
        application_details_copy: 'NOTIFY_SEND_APPLICATION_DETAIL_CY_TEMPLATE_ID',
        application_details_text: 'NOTIFY_SEND_APPLICATION_DETAIL_TEXT_CY_TEMPLATE_ID',
        first_reminder: 'NOTIFY_CASE_FIRST_REMINDER_CY_TEMPLATE_ID',
        last_reminder: 'NOTIFY_CASE_LAST_REMINDER_CY_TEMPLATE_ID'
      }
    }
  end

  before do
    allow(ENV).to receive(:fetch).with('NOTIFY_STATISTICS_REPORT_TEMPLATE_ID').and_return('statistics-report')
    allow(ENV).to receive(:fetch).with('NOTIFY_REPORT_PROBLEM_TEMPLATE_ID').and_return('report-problem-template')
    allow(ENV).to receive(:fetch).with('NOTIFY_GLIMR_GENERATION_COMPLETE_ID').and_return('glimr-generation-template')
    allow(ENV).to receive(:fetch).with('GOVUK_NOTIFY_API_KEY').and_return('dev_test-7bdad799-cfd7-4b9c-aafd-5d3162595af8-9e8cfc38-73f5-4164-b2f5-d5a9aa25bcdb')
    stub_const('GOVUK_NOTIFY_TEMPLATES', govuk_notify_templates)
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

    it_behaves_like 'a Notify mail', template_id: 'NOTIFY_NEW_CASE_SAVED_TEMPLATE_ID'

    it 'has the right keys' do
      expect(mail.govuk_notify_personalisation).to eq({
        appeal_or_application: :appeal,
        draft_expire_in_days: 14,
        show_deadline_warning: 'yes',
        resume_case_link: "https://tax.justice.uk/#{I18n.locale}/users/cases/4a362e1c-48eb-40e3-9458-a31ead3f30a4/resume",
        resume_case_cy_link: "https://tax.justice.uk/cy/users/cases/4a362e1c-48eb-40e3-9458-a31ead3f30a4/resume"
      })
    end
  end

  describe '#reset_password_instructions' do
    let(:mail) { described_class.reset_password_instructions(user, token) }
    let(:user) { User.new(email: 'shirley.schmidt@cranepooleandschmidt.com') }
    let(:token) { '0xDEADBEEF' }

    before { allow(TribunalCase).to receive(:latest_case).and_return(tribunal_case) }

    it_behaves_like 'a Notify mail', template_id: 'NOTIFY_RESET_PASSWORD_TEMPLATE_ID'

    it 'has the right keys' do
      expect(mail.govuk_notify_personalisation).to eq({
        reset_url: "https://tax.justice.uk/#{I18n.locale}/users/password/edit?reset_password_token=0xDEADBEEF",
        reset_cy_url: "https://tax.justice.uk/cy/users/password/edit?reset_password_token=0xDEADBEEF"
      })
    end
  end

  describe '#password_change' do
    let(:mail) { described_class.password_change(user) }
    let(:user) { User.new(email: 'shirley.schmidt@cranepooleandschmidt.com') }

    before { allow(TribunalCase).to receive(:latest_case).and_return(tribunal_case) }

    it_behaves_like 'a Notify mail', template_id: 'NOTIFY_CHANGE_PASSWORD_TEMPLATE_ID'

    it 'has the right keys' do
      expect(mail.govuk_notify_personalisation).to eq({
        portfolio_url: "https://tax.justice.uk/#{I18n.locale}/users/cases",
        portfolio_cy_url: "https://tax.justice.uk/cy/users/cases"
      })
    end
  end

  describe '#glimr_batch_complete' do
    let(:status) { double('status', total: 3, failures: 1) }
    let(:mail) { described_class.glimr_batch_complete('test@example.com', status) }

    it_behaves_like 'a Notify mail', template_id: 'glimr-generation-template'

    it "has the right keys" do
      expect(mail.govuk_notify_personalisation).to eq({
        successes: 2,
        total: 3
      })
    end
  end

  describe 'taxpayer_case_confirmation' do
    let(:mail) { described_class.taxpayer_case_confirmation(tribunal_case) }

    it_behaves_like 'a Notify mail', template_id: 'NOTIFY_CASE_CONFIRMATION_TEMPLATE_ID'

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
            template_id: 'NOTIFY_CASE_CONFIRMATION_TEMPLATE_ID',
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

    it_behaves_like 'a Notify mail', template_id: 'NOTIFY_FTT_CASE_NOTIFICATION_TEMPLATE_ID'

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
    let(:mail) { described_class.incomplete_case_reminder(tribunal_case, :first_reminder) }
    let(:user) { instance_double(User, email: 'user@example.com') }

    before do
      allow(tribunal_case).to receive(:user).and_return(user)
    end

    it_behaves_like 'a Notify mail', template_id: 'NOTIFY_CASE_FIRST_REMINDER_TEMPLATE_ID'

    context 'recipient' do
      it { expect(mail.to).to eq(['user@example.com']) }
    end

    context 'personalisation' do
      it 'sets the personalisation' do
        expect(
          mail.govuk_notify_personalisation.keys
        ).to eq([:appeal_or_application, :show_deadline_warning, :resume_case_link, :resume_case_cy_link])
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

    it_behaves_like 'a Notify mail', template_id: 'NOTIFY_SEND_APPLICATION_DETAIL_TEMPLATE_ID'

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
  end

  describe 'application_details_text' do
    before do
      Timecop.freeze(Time.zone.local(2017, 1, 1, 12, 0, 0))
    end
    after do
      Timecop.return
    end
    it 'sends the text' do
      expect(tribunal_case).to receive(:send)
        .with(:taxpayer_contact_phone)
        .and_return('07777777777')

      expect_any_instance_of(Notifications::Client).to receive(:send_sms).
        with({
          phone_number: '07777777777',
          template_id: 'NOTIFY_SEND_APPLICATION_DETAIL_TEXT_TEMPLATE_ID',
          reference: case_reference,
          personalisation: {
            appeal_or_application: :appeal,
            submission_date_and_time: '1 January 2017 12:00hrs',
          },
        })
      NotifyMailer.new.application_details_text(tribunal_case, :taxpayer, "text content")
    end
  end
end
