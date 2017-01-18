require 'spec_helper'

RSpec.describe Steps::Cost::CaseTypeShowMoreForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    case_type:     case_type
  } }
  let(:tribunal_case) { instance_double(TribunalCase, case_type: nil) }
  let(:case_type) { nil }

  subject { described_class.new(arguments) }

  describe '.choices' do
    it 'excludes choices already in the previous form' do
      allow(Steps::Cost::CaseTypeForm).to receive(:choices).and_return([:bingo_duty])
      expect(described_class.choices).to_not include(:bingo_duty)
    end
  end

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case) { nil }
      let(:case_type)     { 'bingo_duty' }

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
      let(:case_type) { 'bingo_duty' }
      let(:case_type_object) { instance_double(CaseType) }

      it 'saves the record' do
        allow(CaseType).to receive(:find_constant).with('bingo_duty').and_return(case_type_object)
        expect(tribunal_case).to receive(:update).with(
          case_type: case_type_object,
          dispute_type: nil,
          penalty_level: nil
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end

    context 'when case_type is already the same on the model' do
      let(:tribunal_case) { instance_double(TribunalCase, case_type: CaseType::BINGO_DUTY) }
      let(:case_type)     { 'bingo_duty' }

      it 'does not save the record but returns true' do
        expect(tribunal_case).to_not receive(:update)
        expect(subject.save).to be(true)
      end
    end
  end
end
