require 'spec_helper'

RSpec.describe ChallengedDecisionForm do
  let(:arguments) { {
    tribunal_case:      tribunal_case,
    challenged_decision: challenged_decision
  } }
  let(:tribunal_case)      { instance_double(TribunalCase, challenged_decision: nil) }
  let(:challenged_decision) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case) { nil }
      let(:challenged_decision) { true }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when challenged_decision is not given' do
      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:challenged_decision]).to_not be_empty
      end
    end

    context 'when challenged_decision is not valid' do
      let(:challenged_decision) { 'wibble' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:challenged_decision]).to_not be_empty
      end
    end

    context 'when challenged_decision is valid' do
      let(:challenged_decision) { true }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          challenged_decision: true,
          case_type: nil,
          dispute_type: nil,
          penalty_amount: nil
        )
        expect(subject.save).to be(true)
      end
    end

    context 'when challenged_decision is already the same on the model' do
      let(:tribunal_case)      { instance_double(TribunalCase, challenged_decision: true) }
      let(:challenged_decision) { true }

      it 'does not save the record but returns true' do
        expect(tribunal_case).to_not receive(:update)
        expect(subject.save).to be(true)
      end
    end
  end
end
