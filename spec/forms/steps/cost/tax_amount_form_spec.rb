require 'spec_helper'

RSpec.describe Steps::Appeal::TaxAmountForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    tax_amount: tax_amount
  } }
  let(:tribunal_case) { instance_double(TribunalCase, tax_amount: nil) }
  let(:tax_amount) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case)  { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when tax_amount is not given' do
      it 'returns true' do
        expect(tribunal_case).to receive(:update).with(
          tax_amount: nil
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end

    context 'when tax_amount is given' do
      let(:tax_amount) { 'about 12345' }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          tax_amount: 'about 12345'
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end
  end
end
