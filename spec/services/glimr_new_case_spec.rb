require 'spec_helper'

RSpec.describe GlimrNewCase do
  let!(:tribunal_case)   { TribunalCase.create(case_attributes) }
  let(:taxpayer_type)    { TaxpayerType::INDIVIDUAL }
  let(:taxpayer_name)    { 'Filomena Keebler' }
  let(:taxpayer_address) { "769 Eleanore Landing\nSuite 225" }

  let(:case_attributes) do
    {
      taxpayer_type: taxpayer_type,
      taxpayer_individual_name: taxpayer_name,
      taxpayer_contact_address: taxpayer_address,
      taxpayer_contact_postcode: 'SW1H 9AJ',
      taxpayer_contact_phone: '0700 12345678',
      taxpayer_contact_email: 'test@example.com',
      taxpayer_company_name: 'Company Name',
      taxpayer_company_fao: 'Destany Fritsch',
      files_collection_ref: 'd29210a8-f2fe-4d6f-ac96-ea4f9fd66687',
    }
  end

  subject { described_class.new(tribunal_case) }

  before do
    allow(ENV).to receive(:fetch).with('TAX_TRIBUNALS_DOWNLOADER_URL').and_return('http://downloader.com')
  end

  describe '.new' do
    it 'accepts a tribunal case' do
      expect(subject.tribunal_case).to eq(tribunal_case)
    end
  end

  describe '#call!' do
    let(:glimr_response_double) {
      double('Response', response_body: {tribunalCaseNumber: 'TC/12345', confirmationCode: 'ABCDEF'})
    }

    # TODO: add all the params once we know what to send
    let(:glimr_params) do
      {
        jurisdictionId: 8,
        onlineMappingCode: 'APPEAL_PENALTY_LOW',
        documentsURL: 'http://downloader.com/d29210a8-f2fe-4d6f-ac96-ea4f9fd66687',
        contactFirstName: 'Filomena',
        contactLastName: 'Keebler',
        contactStreet1: '769 Eleanore Landing',
        contactStreet2: 'Suite 225',
        contactPostalCode: 'SW1H 9AJ',
        contactPhone: '0700 12345678',
        contactEmail: 'test@example.com'
      }
    end

    context "Glimr call happens" do

      before do
        expect(GlimrApiClient::RegisterNewCase).to receive(:call).
          with(hash_including(glimr_params)).and_return(glimr_response_double)
        allow(tribunal_case).to receive(:mapping_code).and_return(MappingCode::APPEAL_PENALTY_LOW)
      end

      context 'registering the case into glimr' do
        it 'returns a GlimrNewCase instance' do
          result = subject.call!
          expect(result).to be_an_instance_of(described_class)
        end

        it 'retrieves the tc_number and conf_code' do
          subject.call!
          expect(subject.case_reference).to eq('TC/12345')
          expect(subject.confirmation_code).to eq('ABCDEF')
        end

        describe 'different variations of the taxpayer name' do
          context 'only a first name' do
            let(:taxpayer_name) { 'Filomena' }
            let(:glimr_params) { {contactFirstName: 'Filomena', contactLastName: nil} }

            it { subject.call! }
          end

          context 'a first name and two last names' do
            let(:taxpayer_name) { 'Filomena Keebler Mayer' }
            let(:glimr_params) { {contactFirstName: 'Filomena', contactLastName: 'Keebler Mayer'} }

            it { subject.call! }
          end
        end

        context 'lengthy addresses' do
          context 'several lines but less than 4' do
            let(:taxpayer_address) { "769 Eleanore Landing\nAnother street\nSuite 225" }
            let(:glimr_params) do
              {
                contactStreet1: '769 Eleanore Landing',
                contactStreet2: 'Another street',
                contactStreet3: 'Suite 225',
              }
            end

            it { subject.call! }
          end

          context 'exceeding the 4 lines limit' do
            let(:taxpayer_address) { "769 Eleanore Landing\nAnother street\nSuite 225\nMore address\nEven more address" }
            let(:glimr_params) do
              {
                contactStreet1: '769 Eleanore Landing',
                contactStreet2: 'Another street',
                contactStreet3: 'Suite 225',
                contactStreet4: 'More address, Even more address'
              }
            end

            it { subject.call! }
          end
        end
      end
    end

    context "Glimr call does not happen" do
      before do
        allow(GlimrApiClient::RegisterNewCase).to receive(:call).
          with(hash_including(glimr_params)).and_return(glimr_response_double)
        allow(tribunal_case).to receive(:mapping_code).and_return(MappingCode::APPEAL_PENALTY_LOW)
      end

      context 'when taxpayer_type is a company' do
        let(:taxpayer_type) { TaxpayerType::COMPANY }
        let(:company_params) {
          glimr_params.except(:contactFirstName, :contactLastName).merge(
            repOrganisationName: 'Company Name', repFAO: 'Destany Fritsch')
        }

        it 'sends required company params but not individual params' do
          expect(GlimrApiClient::RegisterNewCase).to receive(:call).
            with(hash_including(company_params)).and_return(glimr_response_double)
          subject.call!
        end
      end


      context 'when there are errors' do
        let(:glimr_response_double) { double('Response', response_body: nil) }

        it 'should raise an exception' do
          expect { subject.call }.to raise_exception(Exception)
        end
      end
    end
  end
end
