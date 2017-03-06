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
    it { should validate_presence_of(:outcome) }

    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case)  { nil }
      let(:outcome) { 'my desired outcome' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
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
