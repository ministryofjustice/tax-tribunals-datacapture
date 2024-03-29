require 'spec_helper'

RSpec.describe Steps::Details::RepresentativeIndividualDetailsForm do
  it_behaves_like 'a contactable entity form',
    entity_type: :representative,
    additional_fields: [
      :representative_individual_first_name,
      :representative_individual_last_name
    ],
    optional_fields: [
      :representative_feedback_consent
    ]

  it_behaves_like 'a validated email', entity_type: :representative,
    additional_fields: [
      :representative_individual_first_name,
      :representative_individual_last_name
    ],
    optional_fields: [
      :representative_feedback_consent
    ]

  it_behaves_like 'a validated phone number', entity_type: :representative,
    additional_fields: [
      :representative_individual_first_name,
      :representative_individual_last_name
    ],
    optional_fields: [
      :representative_feedback_consent
    ]

  describe '#name_fields' do
    specify { expect(subject.name_fields).to eq([:representative_individual_first_name, :representative_individual_last_name]) }
  end

  describe 'first name validations' do
    subject { described_class.new(
      tribunal_case: instance_double(TribunalCase, started_by_representative?: false),
      representative_contact_email: 'test@example.com',
      representative_individual_first_name: 'a'*300,
      representative_individual_last_name: 'a'*10) }

    it 'length must be less than 256' do
      expect(subject).not_to be_valid
      expect(subject.errors[:representative_individual_first_name]).to be_present
    end
  end

  describe 'last name validations' do
    subject { described_class.new(
      tribunal_case: instance_double(TribunalCase, started_by_representative?: false),
      representative_contact_email: 'test@example.com',
      representative_individual_first_name: 'a'*10,
      representative_individual_last_name: 'a'*300) }

    it 'length must be less than 256' do
      expect(subject).not_to be_valid
      expect(subject.errors[:representative_individual_last_name]).to be_present
    end
  end

  describe '#show_fao?' do
    specify { expect(subject.show_fao?).to eq(false) }
  end

  describe '#show_registration_number?' do
    specify { expect(subject.show_registration_number?).to eq(false) }
  end

  context 'when the case is started by a representative' do
    subject { described_class.new(tribunal_case: tribunal_case) }

    describe '#representative_contact_email' do
      let(:tribunal_case) { instance_double(TribunalCase, started_by_representative?: true) }
      it { should validate_email(:representative_contact_email) }
    end
  end

  context 'when the case is not started by a representative' do
    subject { described_class.new(tribunal_case: tribunal_case) }

    describe '#representative_contact_email' do
      let(:tribunal_case) { instance_double(TribunalCase, started_by_representative?: false) }

      it 'email is required' do
        subject.valid?
        expect(subject.errors[:representative_contact_email]).to be_present
      end

      it 'email is validated if filled' do
        should validate_email(:representative_contact_email)
      end
    end
  end
end
