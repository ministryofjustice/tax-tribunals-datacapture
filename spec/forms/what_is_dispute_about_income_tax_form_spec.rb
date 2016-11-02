require 'rails_helper'

RSpec.describe WhatIsDisputeAboutIncomeTaxForm do
  let(:arguments) { {
    tribunal_case:         tribunal_case,
    what_is_dispute_about: what_is_dispute_about
  } }
  let(:tribunal_case)         { instance_double(TribunalCase, what_is_dispute_about: nil) }
  let(:what_is_dispute_about) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case)         { nil }
      let(:what_is_dispute_about) { 'amount_of_tax_owed' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when what_is_dispute_about is not given' do
      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:what_is_dispute_about]).to_not be_empty
      end
    end

    context 'when what_is_dispute_about is not valid' do
      let(:what_is_dispute_about) { 'feliz-navidad' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:what_is_dispute_about]).to_not be_empty
      end
    end

    context 'when what_is_dispute_about is valid' do
      let(:what_is_dispute_about) { 'paye_coding_notice' }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with( what_is_dispute_about: 'paye_coding_notice')
        expect(subject.save).to be(true)
      end
    end
  end
end
