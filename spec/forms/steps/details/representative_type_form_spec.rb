require 'spec_helper'

RSpec.describe Steps::Details::RepresentativeTypeForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    representative_type: representative_type
  } }
  let(:tribunal_case) { instance_double(TribunalCase, representative_type: nil) }
  let(:representative_type) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case)  { nil }
      let(:representative_type) { 'company' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when representative_type is not given' do
      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:representative_type]).to_not be_empty
      end
    end

    context 'when representative_type is not valid' do
      let(:representative_type) { 'denny_crane' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:representative_type]).to_not be_empty
      end
    end

    context 'when representative_type is valid' do
      let(:representative_type) { 'individual' }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          representative_type: ContactableEntityType::INDIVIDUAL,
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

    context 'when representative_type is already the same on the model' do
      let(:tribunal_case) {
        instance_double(
          TribunalCase,
          representative_type: ContactableEntityType.new(:individual)
        )
      }
      let(:representative_type) { 'individual' }

      it 'does not save the record but returns true' do
        expect(tribunal_case).to_not receive(:update)
        expect(subject.save).to be(true)
      end
    end
  end
end
