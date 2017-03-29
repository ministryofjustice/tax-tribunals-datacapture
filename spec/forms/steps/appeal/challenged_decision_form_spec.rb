require 'spec_helper'

RSpec.describe Steps::Appeal::ChallengedDecisionForm do
  let(:arguments) { {
    tribunal_case:      tribunal_case,
    challenged_decision: challenged_decision
  } }
  let(:tribunal_case) { instance_double(TribunalCase, case_type: case_type, challenged_decision: nil) }
  let(:case_type) { nil }
  let(:challenged_decision) { nil }

  subject { described_class.new(arguments) }

  describe '#heading_translation_key' do
    context 'when the case type is direct' do
      let(:case_type) { CaseType.new(:foo, direct_tax: true) }

      it 'returns the correct key' do
        expect(subject.heading_translation_key).to eq('.heading_direct')
      end
    end

    context 'when the case type is indirect' do
      let(:case_type) { CaseType.new(:bar, direct_tax: false) }

      it 'returns the correct key' do
        expect(subject.heading_translation_key).to eq('.heading_indirect')
      end
    end
  end

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case) { nil }
      let(:challenged_decision) { 'yes' }

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
      let(:challenged_decision) { 'no' }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          challenged_decision: ChallengedDecision::NO,
          challenged_decision_status: nil,
          dispute_type: nil,
          dispute_type_other_value: nil,
          penalty_level: nil,
          penalty_amount: nil,
          tax_amount: nil
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end

    context 'when challenged_decision is already the same on the model' do
      let(:tribunal_case)      { instance_double(TribunalCase, challenged_decision: ChallengedDecision::YES) }
      let(:challenged_decision) { 'yes' }

      it 'does not save the record but returns true' do
        expect(tribunal_case).to_not receive(:update)
        expect(subject.save).to be(true)
      end
    end
  end
end
