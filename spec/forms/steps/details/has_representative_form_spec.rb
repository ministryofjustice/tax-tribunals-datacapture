require 'spec_helper'

RSpec.describe Steps::Details::HasRepresentativeForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    has_representative: has_representative
  } }
  let(:tribunal_case) { instance_double(TribunalCase, has_representative: nil) }
  let(:has_representative) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case)  { nil }
      let(:has_representative) { 'yes' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when has_representative is not given' do
      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:has_representative]).to_not be_empty
      end
    end

    context 'when has_representative is not valid' do
      let(:has_representative) { 'Alan Shore' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:has_representative]).to_not be_empty
      end
    end

    context 'when has_representative is valid' do
      let(:has_representative) { 'yes' }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          has_representative: HasRepresentative::YES,
          representative_professional_status: nil,
          representative_individual_first_name: nil,
          representative_individual_last_name: nil,
          representative_organisation_name: nil,
          representative_organisation_registration_number: nil,
          representative_organisation_fao: nil,
          representative_contact_address: nil,
          representative_contact_postcode: nil,
          representative_contact_email: nil,
          representative_contact_phone: nil
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end

    context 'when has_representative is already the same on the model' do
      let(:tribunal_case) {
        instance_double(
          TribunalCase,
          has_representative: HasRepresentative::NO
        )
      }
      let(:has_representative) { 'no' }

      it 'does not save the record but returns true' do
        expect(tribunal_case).to_not receive(:update)
        expect(subject.save).to be(true)
      end
    end
  end
end
