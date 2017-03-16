require 'spec_helper'

RSpec.describe RepresentativeDetailsPresenter do
  subject { described_class.new(tribunal_case) }
  let(:tribunal_case) {
    TribunalCase.new(
      has_representative: has_representative,
      representative_type: representative_type,
      representative_individual_first_name: representative_individual_first_name,
      representative_individual_last_name: representative_individual_last_name,
      representative_contact_address: representative_contact_address,
      representative_contact_postcode: representative_contact_postcode,
      representative_contact_email: representative_contact_email,
      representative_contact_phone: representative_contact_phone,
      representative_organisation_name: representative_organisation_name,
      representative_organisation_fao: representative_organisation_fao,
      representative_organisation_registration_number: representative_organisation_registration_number
    )
  }
  let(:paths) { Rails.application.routes.url_helpers }

  let(:has_representative) { nil }
  let(:representative_type) { nil }
  let(:representative_individual_first_name) { 'Firstname' }
  let(:representative_individual_last_name) { 'Lastname' }
  let(:representative_contact_address) { 'Address' }
  let(:representative_contact_postcode) { 'Postcode' }
  let(:representative_contact_email) { 'Email' }
  let(:representative_contact_phone) { 'Phone' }
  let(:representative_organisation_name) { 'Company name' }
  let(:representative_organisation_fao) { 'Company contact' }
  let(:representative_organisation_registration_number) { '0123' }

  describe '#present?' do
    context 'when the case has a representative' do
      let(:has_representative) { HasRepresentative::YES }

      it { is_expected.to be_present }
    end

    context 'when the case does not have a representative' do
      let(:has_representative) { HasRepresentative::NO }

      it { is_expected.to_not be_present }
    end
  end

  describe '#name' do
    context 'when representative is not an organisation' do
      let(:representative_type) { OpenStruct.new(value: :anything, organisation?: false) }

      it 'should returns the concatenated individual name fields' do
        expect(subject.name).to eq('Firstname Lastname')
      end
    end

    context 'when representative is an organisation' do
      let(:representative_type) { OpenStruct.new(value: :anything, organisation?: true) }

      it 'should returns the representative_organisation_fao field' do
        expect(subject.name).to eq('Company contact')
      end
    end
  end

  describe '#phone' do
    it 'returns the phone number' do
      expect(subject.phone).to eq('Phone')
    end
  end

  describe '#email' do
    it 'returns the email' do
      expect(subject.email).to eq('Email')
    end
  end

  describe '#address' do
    context 'when representative is not an organisation' do
      let(:representative_type) { OpenStruct.new(value: :anything, organisation?: false) }
      let(:representative_organisation_name) { nil }

      it 'returns the address, including postcode' do
        expect(subject.address).to eq("Address\nPostcode")
      end
    end

    context 'when representative is an organisation' do
      let(:representative_type) { OpenStruct.new(value: :anything, organisation?: true) }
      let(:representative_organisation_name) { 'Company name' }

      it 'returns the address, including postcode' do
        expect(subject.address).to eq("Company name\nAddress\nPostcode")
      end
    end
  end

  describe '#proforma_present?' do
    let(:tribunal_case) { instance_double(TribunalCase, representative_approval_file_name: file_name) }

    context 'when a document was uploaded' do
      let(:file_name) { 'document.txt' }
      it { expect(subject.proforma_present?).to eq(true) }
    end

    context 'when no document was uploaded' do
      let(:file_name) { nil }
      it { expect(subject.proforma_present?).to eq(false) }
    end
  end
end
