require 'spec_helper'

RSpec.describe Steps::Cost::PenaltyAmountForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    penalty_level: penalty_level
  } }
  let(:tribunal_case) { instance_double(TribunalCase, penalty_level: nil) }
  let(:penalty_level) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case) { nil }
      let(:penalty_level) { 'penalty_level_1' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when penalty_level is not given' do
      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:penalty_level]).to_not be_empty
      end
    end

    context 'when penalty_level is not valid' do
      let(:penalty_level) { 'loads-of-$$$' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:penalty_level]).to_not be_empty
      end
    end

    context 'when penalty_level is valid' do
      let(:penalty_level) { 'penalty_level_1' }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          penalty_level: PenaltyLevel::PENALTY_LEVEL_1
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end
  end
end
