require 'rails_helper'

RSpec.describe CaseReminders do
  let(:rule_set) { instance_double(ReminderRuleSet, email_template_id: 'test-template', status_transition_to: 'another-status') }
  let(:tribunal_case) { instance_double(TribunalCase) }

  subject { described_class.new(rule_set: rule_set) }

  describe '#run' do
    before do
      allow(rule_set).to receive(:find_each).and_yield(tribunal_case)
    end

    it 'should send the email and update the tribunal case status' do
      expect(NotifyMailer).to receive(:incomplete_case_reminder).with(tribunal_case, 'test-template').and_return(double.as_null_object)
      expect(tribunal_case).to receive(:update).with(case_status: 'another-status')
      subject.run
    end
  end
end
