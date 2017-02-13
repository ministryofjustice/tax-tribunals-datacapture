require 'spec_helper'

RSpec.describe Steps::Details::RepresentativeIsLegalProfessionalForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    representative_is_legal_professional: representative_is_legal_professional
  } }
  let(:tribunal_case) { instance_double(TribunalCase, representative_is_legal_professional: nil) }
  let(:representative_is_legal_professional) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case)  { nil }
      let(:representative_is_legal_professional) { 'yes' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when representative_is_legal_professional is not given' do
      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:representative_is_legal_professional]).to_not be_empty
      end
    end

    context 'when representative_is_legal_professional is not valid' do
      let(:representative_is_legal_professional) { 'INVALID VALUE' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:representative_is_legal_professional]).to_not be_empty
      end
    end

    context 'when representative_is_legal_professional is valid' do
      let(:representative_is_legal_professional) { 'yes' }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          representative_is_legal_professional: RepresentativeIsLegalProfessional::YES
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end

    context 'when representative_is_legal_professional is already the same on the model' do
      let(:tribunal_case) {
        instance_double(
          TribunalCase,
          representative_is_legal_professional: RepresentativeIsLegalProfessional::NO
        )
      }
      let(:representative_is_legal_professional) { 'no' }

      it 'does not save the record but returns true' do
        expect(tribunal_case).to_not receive(:update)
        expect(subject.save).to be(true)
      end
    end
  end
end
