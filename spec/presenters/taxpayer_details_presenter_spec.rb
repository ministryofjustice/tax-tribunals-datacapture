require 'spec_helper'

RSpec.describe TaxpayerDetailsPresenter do
  subject { described_class.new(tribunal_case) }
  let(:tribunal_case) {
    TribunalCase.new(
      taxpayer_type: taxpayer_type,
      taxpayer_individual_name: taxpayer_individual_name,
      taxpayer_contact_address: taxpayer_contact_address,
      taxpayer_contact_postcode: taxpayer_contact_postcode,
      taxpayer_contact_email: taxpayer_contact_email,
      taxpayer_contact_phone: taxpayer_contact_phone,
      taxpayer_company_name: taxpayer_company_name,
      taxpayer_company_fao: taxpayer_company_fao,
      taxpayer_company_registration_number: taxpayer_company_registration_number
    )
  }
  let(:paths) { Rails.application.routes.url_helpers }

  let(:taxpayer_type) { ContactableEntityType::INDIVIDUAL }
  let(:taxpayer_individual_name) { 'Name' }
  let(:taxpayer_contact_address) { 'Address' }
  let(:taxpayer_contact_postcode) { 'Postcode' }
  let(:taxpayer_contact_email) { 'Email' }
  let(:taxpayer_contact_phone) { 'Phone' }
  let(:taxpayer_company_name) { 'Company name' }
  let(:taxpayer_company_fao) { 'Company contact' }
  let(:taxpayer_company_registration_number) { '0123' }

  describe '#name' do
    context 'when taxpayer is an individual' do
      let(:taxpayer_type) { ContactableEntityType::INDIVIDUAL }

      it 'should returns the taxpayer_individual_name field' do
        expect(subject.name).to eq('Name')
      end
    end

    context 'when taxpayer is a company' do
      let(:taxpayer_type) { ContactableEntityType::COMPANY }

      it 'should returns the taxpayer_company_fao field' do
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
    context 'when taxpayer is an individual' do
      let(:taxpayer_type) { ContactableEntityType::INDIVIDUAL }
      let(:taxpayer_company_name) { nil }

      it 'returns the address, including postcode' do
        expect(subject.address).to eq("Address\nPostcode")
      end
    end

    context 'when taxpayer is a company' do
      let(:taxpayer_type) { ContactableEntityType::COMPANY }
      let(:taxpayer_company_name) { 'Company name' }

      it 'returns the address, including postcode' do
        expect(subject.address).to eq("Company name\nAddress\nPostcode")
      end
    end
  end
end
