require 'spec_helper'

RSpec.describe Steps::Cost::PenaltyAndTaxAmountsForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    penalty_amount: penalty_amount,
    tax_amount: tax_amount
  } }
  let(:tribunal_case)  { instance_double(TribunalCase, penalty_amount: nil, tax_amount: nil) }
  let(:penalty_amount) { nil }
  let(:tax_amount)     { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case)  { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when penalty and tax amounts are not given' do
      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          penalty_amount: nil,
          tax_amount: nil
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end

    context 'when penalty and tax amounts are given' do
      let(:penalty_amount) { 'value 1' }
      let(:tax_amount)     { 'value 2' }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          penalty_amount: 'value 1',
          tax_amount: 'value 2'
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end
  end
end
