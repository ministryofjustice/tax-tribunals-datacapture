require 'spec_helper'

RSpec.describe Steps::Details::RepresentativeIndividualDetailsForm do
  it_behaves_like 'a contactable entity form',
    entity_type: :representative,
    additional_fields: [
      :representative_individual_first_name,
      :representative_individual_last_name
    ]

  describe '#name_fields' do
    specify { expect(subject.name_fields).to eq([:representative_individual_first_name, :representative_individual_last_name]) }
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

      it 'email is not required' do
        subject.valid?
        expect(subject.errors[:representative_contact_email]).to be_blank
      end

      it 'email is validated if filled' do
        should validate_email(:representative_contact_email)
      end
    end
  end
end
