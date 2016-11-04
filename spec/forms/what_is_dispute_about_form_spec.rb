require 'rails_helper'

RSpec.describe WhatIsDisputeAboutForm do
  let(:arguments) { {
    tribunal_case:         tribunal_case,
    what_is_dispute_about: what_is_dispute_about
  } }
  let(:tribunal_case) {
    instance_double(
      TribunalCase,
      what_is_appeal_about:  what_is_appeal_about,
      what_is_dispute_about: nil
    )
  }
  let(:what_is_appeal_about)  { nil }
  let(:what_is_dispute_about) { nil }

  subject { described_class.new(arguments) }

  describe '#choices' do
    context 'when the appeal is about income tax' do
      let(:what_is_appeal_about) { 'income_tax' }

      it 'includes PAYE coding notice' do
        expect(subject.choices).to eq(%w(
          late_return_or_payment
          amount_of_tax_owed
          paye_coding_notice
        ))
      end
    end

    context 'when the appeal is not about income tax' do
      let(:what_is_appeal_about) { 'vat' }

      it 'does not include PAYE coding notice' do
        expect(subject.choices).to eq(%w(
          late_return_or_payment
          amount_of_tax_owed
        ))
      end
    end
  end

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
      let(:what_is_dispute_about) { 'amount_of_tax_owed' }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          what_is_dispute_about: 'amount_of_tax_owed',
          what_is_penalty_or_surcharge_amount: nil
        )
        expect(subject.save).to be(true)
      end
    end


    context 'when what_is_dispute_about is only valid for income tax' do
      let(:what_is_dispute_about) { 'paye_coding_notice' }

      context 'and the appeal is about income tax' do
        let(:what_is_appeal_about) { 'income_tax' }

        it 'is valid' do
          expect(subject).to be_valid
        end
      end

      context 'and the appeal is not about income tax' do
        let(:what_is_appeal_about) { 'vat' }

        it 'is not valid' do
          expect(subject).to_not be_valid
        end
      end
    end

    context 'when what_is_dispute_about is already the same on the model' do
      let(:tribunal_case) {
        instance_double(
          TribunalCase,
          what_is_dispute_about: 'paye_coding_notice', what_is_appeal_about:  'income_tax'
        )
      }
      let(:what_is_dispute_about) { 'paye_coding_notice' }

      it 'does not save the record but returns true' do
        expect(tribunal_case).to_not receive(:update)
        expect(subject.save).to be(true)
      end
    end
  end
end
