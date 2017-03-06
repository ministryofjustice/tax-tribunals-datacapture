require 'spec_helper'

RSpec.describe Steps::Details::TaxpayerIndividualDetailsForm do
  it_behaves_like 'a contactable entity form',
    entity_type: :taxpayer,
    additional_fields: [
      :taxpayer_individual_first_name,
      :taxpayer_individual_last_name
  ]

  describe '#name_fields' do
    specify { expect(subject.name_fields).to eq([:taxpayer_individual_first_name, :taxpayer_individual_last_name]) }
  end

  describe '#show_fao?' do
    specify { expect(subject.show_fao?).to eq(false) }
  end

  describe '#show_registration_number?' do
    specify { expect(subject.show_registration_number?).to eq(false) }
  end

  context 'when the case is started by the taxpayer' do
    subject { described_class.new(tribunal_case: tribunal_case) }

    describe '#taxpayer_contact_email' do
      let(:tribunal_case) { instance_double(TribunalCase, started_by_taxpayer?: true) }
      it { should validate_email(:taxpayer_contact_email) }
    end
  end

  context 'when the case is not started by the taxpayer' do
    subject { described_class.new(tribunal_case: tribunal_case) }

    describe '#taxpayer_contact_email' do
      let(:tribunal_case) { instance_double(TribunalCase, started_by_taxpayer?: false) }

      it 'email is not required' do
        subject.valid?
        expect(subject.errors[:taxpayer_contact_email]).to be_blank
      end

      it 'email is validated if filled' do
        should validate_email(:taxpayer_contact_email)
      end
    end
  end
end
