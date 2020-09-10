require 'spec_helper'

RSpec.describe Steps::Closure::CaseTypeForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    closure_case_type: closure_case_type
  } }
  let(:tribunal_case) { instance_double(TribunalCase, closure_case_type: nil) }
  let(:closure_case_type) { nil }

  subject { described_class.new(arguments) }

  describe '.choices' do
    it 'returns the relevant choices' do
      expect(described_class.choices).to match_array([
        ClosureCaseType::PERSONAL_RETURN,
        ClosureCaseType::COMPANY_RETURN,
        ClosureCaseType::PARTNERSHIP_RETURN,
        ClosureCaseType::TRUSTEE_RETURN,
        ClosureCaseType::ENTERPRISE_MGMT_INCENTIVES,
        ClosureCaseType::NON_RESIDENT_CAPITAL_GAINS_TAX,
        ClosureCaseType::STAMP_DUTY_LAND_TAX_RETURN,
        ClosureCaseType::TRANSACTIONS_IN_SECURITIES,
        ClosureCaseType::CLAIM_OR_AMENDMENT,
      ])
    end
  end

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case)  { nil }
      let(:closure_case_type) { 'personal_return' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when closure_case_type is not given' do
      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:closure_case_type]).to_not be_empty
      end
    end

    context 'when closure_case_type is not valid' do
      let(:closure_case_type) { 'INVALID VALUE' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:closure_case_type]).to_not be_empty
      end
    end

    context 'when closure_case_type is valid' do
      let(:closure_case_type) { 'personal_return' }
      let(:closure_case_type_object) { ClosureCaseType::PERSONAL_RETURN }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          closure_case_type: closure_case_type_object,
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end

    context 'when closure_case_type is already the same on the model' do
      let(:tribunal_case) { instance_double(TribunalCase, closure_case_type: ClosureCaseType::PERSONAL_RETURN) }
      let(:closure_case_type) { 'personal_return' }

      it 'does not save the record but returns true' do
        expect(tribunal_case).to_not receive(:update)
        expect(subject.save).to be(true)
      end
    end
  end
end
