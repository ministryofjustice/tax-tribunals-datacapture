require 'rails_helper'

RSpec.describe PenaltyAmountForm do
  let(:arguments) { {
    tribunal_case:                       tribunal_case,
    penalty_amount: penalty_amount
  } }
  let(:tribunal_case)         { instance_double(TribunalCase, penalty_amount: nil) }
  let(:penalty_amount) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case)                       { nil }
      let(:penalty_amount) { '100_or_less' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when penalty_amount is not given' do
      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:penalty_amount]).to_not be_empty
      end
    end

    context 'when penalty_amount is not valid' do
      let(:penalty_amount) { 'loads-of-$$$' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:penalty_amount]).to_not be_empty
      end
    end

    context 'when penalty_amount is valid' do
      let(:penalty_amount) { '100_or_less' }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          penalty_amount: '100_or_less'
        )
        expect(subject.save).to be(true)
      end
    end
  end
end
