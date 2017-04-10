require 'rails_helper'

RSpec.describe ReminderRuleSet do
  before do
    allow(ENV).to receive(:fetch).with('NOTIFY_CASE_FIRST_REMINDER_TEMPLATE_ID').and_return('first-reminder-template')
    allow(ENV).to receive(:fetch).with('NOTIFY_CASE_LAST_REMINDER_TEMPLATE_ID').and_return('last-reminder-template')
  end

  describe '.first_reminder' do
    subject { described_class.first_reminder }

    context '#created_days_ago' do
      it { expect(subject.created_days_ago).to eq(8) }
    end

    context '#status_in' do
      it { expect(subject.status_in).to match_array([nil]) }
    end

    context '#status_transition_to' do
      it { expect(subject.status_transition_to).to eq(CaseStatus::FIRST_REMINDER_SENT) }
    end

    context '#email_template_id' do
      it { expect(subject.email_template_id).to eq('first-reminder-template') }
    end
  end

  describe '.last_reminder' do
    subject { described_class.last_reminder }

    context '#created_days_ago' do
      it { expect(subject.created_days_ago).to eq(10) }
    end

    context '#status_in' do
      it { expect(subject.status_in).to match_array([CaseStatus::FIRST_REMINDER_SENT]) }
    end

    context '#status_transition_to' do
      it { expect(subject.status_transition_to).to eq(CaseStatus::LAST_REMINDER_SENT) }
    end

    context '#email_template_id' do
      it { expect(subject.email_template_id).to eq('last-reminder-template') }
    end
  end

  describe '#find_each' do
    let(:dummy_config) do
      {
        created_days_ago: 3,
        status_in: ['status'],
        status_transition_to: 'another_status',
        email_template_id: 'test-template'
      }
    end

    subject { described_class.new(dummy_config) }

    before do
      travel_to Time.now
    end

    it 'filters the cases' do
      expect(TribunalCase).to receive(:where).with(case_status: ['status']).and_return(TribunalCase)
      expect(TribunalCase).to receive(:where).with('created_at <= ?', 3.days.ago).and_return(TribunalCase)
      subject.find_each
    end

    it 'it returns an enumerator' do
      expect(subject.find_each).to be_an(Enumerator)
    end
  end
end
