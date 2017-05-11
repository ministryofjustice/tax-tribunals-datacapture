require 'spec_helper'

RSpec.describe ChallengedDecisionStatus do
  describe '.values' do
    it 'returns all statuses' do
      expect(described_class.values.map(&:to_s)).to eq(%w(
        received
        pending
        overdue
        refused
        not_required
        appealing_directly
        appeal_late_rejection
        review_late_rejection
      ))
    end
  end
end
