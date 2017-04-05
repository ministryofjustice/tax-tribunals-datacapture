require 'spec_helper'

RSpec.describe CaseStatus do
  let(:state) { :foo }
  subject { described_class.new(state) }

  describe '#submitted?' do
    context 'for a status of `SUBMITTED`' do
      let(:state) { :submitted }

      it 'returns true' do
        expect(subject.submitted?).to be(true)
      end
    end

    context 'for a status of `SUBMIT_IN_PROGRESS`' do
      let(:state) { :submit_in_progress }

      it 'returns true' do
        expect(subject.submitted?).to be(true)
      end
    end

    context 'for a status of `FIRST_REMINDER_SENT`' do
      let(:state) { :first_reminder_sent }

      it 'returns false' do
        expect(subject.submitted?).to be(false)
      end
    end

    context 'for a status of `LAST_REMINDER_SENT`' do
      let(:state) { :last_reminder_sent }

      it 'returns false' do
        expect(subject.submitted?).to be(false)
      end
    end
  end
end
