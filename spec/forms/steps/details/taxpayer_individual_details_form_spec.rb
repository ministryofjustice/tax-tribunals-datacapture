require 'spec_helper'

RSpec.describe Steps::Details::TaxpayerIndividualDetailsForm do
  it_behaves_like 'a contactable entity form',
    entity_type: :taxpayer,
    additional_fields: [
      :taxpayer_individual_first_name,
      :taxpayer_individual_last_name,
      :taxpayer_feedback_consent
  ]

  it_behaves_like 'a validated email', entity_type: :taxpayer,
    additional_fields: [
      :taxpayer_individual_first_name,
      :taxpayer_individual_last_name,
      :taxpayer_feedback_consent
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

  # This test is necessary because NormalisedEmailType was working as expected on email fields,
  # but the TribunalCase#sanitize was reverting back some characters to invalid ones on save
  context 'NormalisedEmailType integration' do
    let(:tribunal_case) { TribunalCase.new }

    subject { described_class.new(
        taxpayer_individual_first_name: 'Bob',
        taxpayer_individual_last_name: 'Smith',
        taxpayer_contact_address: 'Address',
        taxpayer_contact_postcode: 'Postcode',
        taxpayer_contact_city: 'City',
        taxpayer_contact_country: 'Country',
        taxpayer_contact_email: taxpayer_contact_email,
        tribunal_case: tribunal_case
    ) }

    context 'normalising hyphens' do
      let(:taxpayer_contact_email) {"email@example\u2010hyphen.com"}

      # Before the fix, TribunalCase#sanitize was converting the normalised hyphen to `&dash;`
      it 'maintain the replaced hyphen on save' do
        subject.save
        expect(tribunal_case.reload.taxpayer_contact_email).to eq('email@example-hyphen.com')
      end
    end

    context 'normalising single quotes' do
      let(:taxpayer_contact_email) {"email\u2019test@example.com"}

      # TribunalCase#sanitize was not affecting normalised single quotes, but this test ensures
      # we don't introduce a regression in the future
      it 'maintain the replaced single quote on save' do
        subject.save
        expect(tribunal_case.reload.taxpayer_contact_email).to eq("email'test@example.com")
      end
    end
  end
end
