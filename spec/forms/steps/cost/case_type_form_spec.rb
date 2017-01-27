require 'spec_helper'

RSpec.describe Steps::Appeal::CaseTypeForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    case_type:     case_type
  } }
  let(:tribunal_case) { instance_double(TribunalCase, case_type: nil) }
  let(:case_type) { nil }

  subject { described_class.new(arguments) }

  describe '.choices' do
    it 'returns the relevant choices' do
      expect(described_class.choices).to eq(%w(
        income_tax
        vat
        capital_gains_tax
        corporation_tax
        inaccurate_return_penalty
        information_notice
        ni_contributions
        _show_more
      ))
    end
  end

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case) { nil }
      let(:case_type)     { 'vat' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when case_type is not given' do
      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:case_type]).to_not be_empty
      end
    end

    context 'when case_type is not valid' do
      let(:case_type) { 'lave-linge-pas-cher' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:case_type]).to_not be_empty
      end
    end

    context 'when case_type is valid' do
      let(:case_type) { 'income_tax' }
      let(:case_type_object) { instance_double(CaseType) }

      it 'saves the record' do
        allow(CaseType).to receive(:find_constant).with('income_tax').and_return(case_type_object)
        expect(tribunal_case).to receive(:update).with(
          case_type: case_type_object,
          dispute_type: nil,
          penalty_level: nil,
          penalty_amount: nil,
          tax_amount: nil
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end

    context 'when case_type is already the same on the model' do
      let(:tribunal_case) { instance_double(TribunalCase, case_type: CaseType::VAT) }
      let(:case_type)     { 'vat' }

      it 'does not save the record but returns true' do
        expect(tribunal_case).to_not receive(:update)
        expect(subject.save).to be(true)
      end
    end
  end
end
