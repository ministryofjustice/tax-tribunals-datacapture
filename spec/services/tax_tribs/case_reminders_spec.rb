require 'rails_helper'

RSpec.describe TaxTribs::CaseReminders do
  let(:rule_set) { instance_double(TaxTribs::ReminderRuleSet, email_template_id: 'test-template', status_transition_to: 'another-status') }
  let(:tribunal_case) { instance_double(TribunalCase) }

  subject { described_class.new(rule_set: rule_set) }

  describe '#run' do
    let(:mailer_double) { double.as_null_object }

    before do
      allow(rule_set).to receive(:find_each).and_yield(tribunal_case)
      allow(NotifyMailer).to receive(:incomplete_case_reminder).with(tribunal_case, 'test-template').and_return(mailer_double)
    end

    it 'should send the email and update the tribunal case status' do
      expect(mailer_double).to receive(:deliver_later)
      expect(tribunal_case).to receive(:update).with(case_status: 'another-status')
      subject.run
    end
  end
end
