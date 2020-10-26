require 'spec_helper'

RSpec.describe Steps::Hardship::DisputedTaxPaidForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    disputed_tax_paid: disputed_tax_paid
  } }
  let(:tribunal_case) { instance_double(TribunalCase, disputed_tax_paid: nil, dispute_type: dispute_type) }
  let(:dispute_type) { nil }
  let(:disputed_tax_paid) { nil }

  subject { described_class.new(arguments) }

  describe '#choices' do
    it 'gets its options from the value object' do
      expect(DisputedTaxPaid).to receive(:values).and_return([DisputedTaxPaid.new(:foo)])
      expect(subject.choices).to eq(['foo'])
    end
  end

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case)     { nil }
      let(:disputed_tax_paid) { 'yes' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when disputed_tax_paid is not given' do
      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:disputed_tax_paid]).to_not be_empty
      end
    end

    context 'when disputed_tax_paid is not valid' do
      let(:disputed_tax_paid) { 'sort_of' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:disputed_tax_paid]).to_not be_empty
      end
    end

    context 'when disputed_tax_paid is valid' do
      let(:disputed_tax_paid) { 'no' }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          disputed_tax_paid: DisputedTaxPaid::NO,
          hardship_review_requested: nil,
          hardship_review_status: nil
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end

    context 'when disputed_tax_paid is already the same on the model' do
      let(:tribunal_case) {
        instance_double(
          TribunalCase,
          dispute_type: DisputeType.new(:anything),
          disputed_tax_paid: DisputedTaxPaid::NO
        )
      }
      let(:disputed_tax_paid) { 'no' }

      it 'does not save the record but returns true' do
        expect(tribunal_case).to_not receive(:update)
        expect(subject.save).to be(true)
      end
    end
  end
end
