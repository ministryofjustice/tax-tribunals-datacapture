require 'spec_helper'

RSpec.describe TaxpayerDetailsPresenter do
  subject { described_class.new(tribunal_case) }
  let(:tribunal_case) {
    TribunalCase.new(
      taxpayer_type: taxpayer_type,
      taxpayer_individual_first_name: taxpayer_individual_first_name,
      taxpayer_individual_last_name: taxpayer_individual_last_name,
      taxpayer_contact_address: taxpayer_contact_address,
      taxpayer_contact_postcode: taxpayer_contact_postcode,
      taxpayer_contact_email: taxpayer_contact_email,
      taxpayer_contact_phone: taxpayer_contact_phone,
      taxpayer_organisation_name: taxpayer_organisation_name,
      taxpayer_organisation_fao: taxpayer_organisation_fao,
      taxpayer_organisation_registration_number: taxpayer_organisation_registration_number
    )
  }
  let(:paths) { Rails.application.routes.url_helpers }

  let(:taxpayer_type) { nil }
  let(:taxpayer_individual_first_name) { 'Firstname' }
  let(:taxpayer_individual_last_name) { 'Lastname' }
  let(:taxpayer_contact_address) { 'Address' }
  let(:taxpayer_contact_postcode) { 'Postcode' }
  let(:taxpayer_contact_email) { 'Email' }
  let(:taxpayer_contact_phone) { 'Phone' }
  let(:taxpayer_organisation_name) { 'Company name' }
  let(:taxpayer_organisation_fao) { 'Company contact' }
  let(:taxpayer_organisation_registration_number) { '0123' }

  describe '#name' do
    context 'when taxpayer is not an organisation' do
      let(:taxpayer_type) { OpenStruct.new(value: :anything, organisation?: false) }

      it 'should returns the concatenated individual name fields' do
        expect(subject.name).to eq('Firstname Lastname')
      end
    end

    context 'when taxpayer is an organisation' do
      let(:taxpayer_type) { OpenStruct.new(value: :anything, organisation?: true) }

      it 'should returns the taxpayer_organisation_fao field' do
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
    context 'when taxpayer is not an organisation' do
      let(:taxpayer_type) { OpenStruct.new(value: :anything, organisation?: false) }
      let(:taxpayer_organisation_name) { nil }

      it 'returns the address, including postcode' do
        expect(subject.address).to eq("Address\nPostcode")
      end
    end

    context 'when taxpayer is an organisation' do
      let(:taxpayer_type) { OpenStruct.new(value: :anything, organisation?: true) }
      let(:taxpayer_organisation_name) { 'Company name' }

      it 'returns the address, including postcode' do
        expect(subject.address).to eq("Company name\nAddress\nPostcode")
      end
    end
  end
end
