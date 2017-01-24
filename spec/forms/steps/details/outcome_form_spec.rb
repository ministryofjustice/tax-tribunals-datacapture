require 'spec_helper'

RSpec.describe Steps::Details::OutcomeForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    outcome: outcome
  } }
  let(:tribunal_case) { instance_double(TribunalCase, outcome: nil) }
  let(:outcome) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case)  { nil }
      let(:outcome) { 'my desired outcome' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when outcome is not given' do
      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:outcome]).to_not be_empty
      end
    end

    context 'when outcome is not valid' do
      let(:outcome) { 'too short' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:outcome]).to_not be_empty
      end
    end

    context 'when outcome is valid' do
      let(:outcome) { 'my desired outcome' }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          outcome: 'my desired outcome'
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end
  end
end
