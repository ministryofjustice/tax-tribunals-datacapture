require 'rails_helper'

RSpec.describe Steps::Cost::DisputeTypeForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    dispute_type:  dispute_type
  } }
  let(:tribunal_case) {
    instance_double(
      TribunalCase,
      case_type:  case_type,
      dispute_type: nil
    )
  }
  let(:case_type)  { nil }
  let(:dispute_type) { nil }

  subject { described_class.new(arguments) }

  describe '#case_challenged?' do
    context 'when the case has been challenged' do
      let(:tribunal_case) {
        instance_double(
          TribunalCase,
          challenged_decision: true
        )
      }

      it 'returns true' do
        expect(subject.case_challenged?).to eq(true)
      end
    end

    context 'when the case has not been challenged' do
      let(:tribunal_case) {
        instance_double(
          TribunalCase,
          challenged_decision: false
        )
      }

      it 'returns false' do
        expect(subject.case_challenged?).to eq(false)
      end
    end
  end

  describe '#choices' do
    context 'when the appeal is about income tax' do
      let(:case_type) { CaseType::INCOME_TAX }

      it 'includes PAYE coding notice' do
        expect(subject.choices).to eq(%w(
          late_return_or_payment
          amount_of_tax_owed
          paye_coding_notice
        ))
      end
    end

    context 'when the appeal is not about income tax' do
      let(:case_type) { CaseType::VAT }

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
      let(:dispute_type) { 'amount_of_tax_owed' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when dispute_type is not given' do
      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:dispute_type]).to_not be_empty
      end
    end

    context 'when dispute_type is not valid' do
      let(:dispute_type) { 'feliz-navidad' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:dispute_type]).to_not be_empty
      end
    end

    context 'when dispute_type is valid' do
      let(:dispute_type) { 'amount_of_tax_owed' }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          dispute_type: DisputeType::AMOUNT_OF_TAX_OWED,
          penalty_amount: nil
        )
        expect(subject.save).to be(true)
      end
    end


    context 'when dispute_type is only valid for income tax' do
      let(:dispute_type) { 'paye_coding_notice' }

      context 'and the appeal is about income tax' do
        let(:case_type) { CaseType::INCOME_TAX }

        it 'is valid' do
          expect(subject).to be_valid
        end
      end

      context 'and the appeal is not about income tax' do
        let(:case_type) { CaseType::VAT }

        it 'is not valid' do
          expect(subject).to_not be_valid
        end
      end
    end

    context 'when dispute_type is already the same on the model' do
      let(:tribunal_case) {
        instance_double(
          TribunalCase,
          dispute_type: DisputeType::PAYE_CODING_NOTICE,
          case_type:    CaseType::INCOME_TAX
        )
      }
      let(:dispute_type) { 'paye_coding_notice' }

      it 'does not save the record but returns true' do
        expect(tribunal_case).to_not receive(:update)
        expect(subject.save).to be(true)
      end
    end
  end
end
