require 'spec_helper'

RSpec.describe Steps::Details::RepresentativeProfessionalStatusForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    representative_professional_status: representative_professional_status
  } }
  let(:tribunal_case) { instance_double(TribunalCase, representative_professional_status: nil) }
  let(:representative_professional_status) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case)  { nil }
      let(:representative_professional_status) { 'friend_or_family' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when representative_professional_status is not given' do
      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:representative_professional_status]).to_not be_empty
      end
    end

    context 'when representative_professional_status is not valid' do
      let(:representative_professional_status) { 'INVALID VALUE' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:representative_professional_status]).to_not be_empty
      end
    end

    context 'when representative_professional_status is valid' do
      let(:representative_professional_status) { 'accountant' }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          has_representative: HasRepresentative::YES,
          representative_professional_status: RepresentativeProfessionalStatus::ACCOUNTANT
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end

    context 'when representative_professional_status is already the same on the model' do
      let(:tribunal_case) {
        instance_double(
          TribunalCase,
          representative_professional_status: RepresentativeProfessionalStatus::ENGLAND_OR_WALES_OR_NI_LEGAL_REP
        )
      }
      let(:representative_professional_status) { 'england_or_wales_or_ni_legal_rep' }

      it 'does not save the record but returns true' do
        expect(tribunal_case).to_not receive(:update)
        expect(subject.save).to be(true)
      end
    end
  end
end
