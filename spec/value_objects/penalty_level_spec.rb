require 'spec_helper'

RSpec.describe PenaltyLevel do
  subject { described_class.new(state) }

  describe '.names' do
    it 'returns names of the penalty levels' do
      expect(described_class.names).to match_array(
        %w(penalty_level_1 penalty_level_2 penalty_level_3))
    end
  end

  describe '.lower_bound' do
    it 'returns nil when level provided is not valid' do
      expect(described_class.lower_bound('INVALID_INPUT')).to be_nil
    end
    it 'returns the lower bound for a given level (as string)' do
      expect(described_class.lower_bound('penalty_level_2')).to eq 100
    end
    it 'returns the lower bound for a given level (as sym)' do
      expect(described_class.lower_bound(:penalty_level_2)).to eq 100
    end
  end

  describe '.upper_bound' do
    it 'returns nil when level provided is not valid' do
      expect(described_class.upper_bound('INVALID_INPUT')).to be_nil
    end
    it 'returns the lower bound for a given level (as string)' do
      expect(described_class.upper_bound('penalty_level_2')).to eq 20000
    end
    it 'returns the lower bound for a given level (as sym)' do
      expect(described_class.upper_bound(:penalty_level_2)).to eq 20000
    end
  end
end