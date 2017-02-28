require 'spec_helper'

RSpec.describe GlimrNewCase do
  let!(:tribunal_case)      { TribunalCase.create(case_attributes) }
  let(:taxpayer_type)       { ContactableEntityType::INDIVIDUAL }
  let(:taxpayer_first_name) { 'Filomena' }
  let(:taxpayer_last_name)  { 'Keebler' }
  let(:taxpayer_address)    { "769 Eleanore Landing\nSuite 225" }

  let(:case_attributes) do
    {
      taxpayer_type: taxpayer_type,
      taxpayer_individual_first_name: taxpayer_first_name,
      taxpayer_individual_last_name: taxpayer_last_name,
      taxpayer_contact_address: taxpayer_address,
      taxpayer_contact_postcode: 'SW1H 9AJ',
      taxpayer_contact_phone: '0700 12345678',
      taxpayer_contact_email: 'test@example.com',
      taxpayer_organisation_name: 'Company Name',
      taxpayer_organisation_fao: 'Destany Fritsch',
      files_collection_ref: 'd29210a8-f2fe-4d6f-ac96-ea4f9fd66687',
    }
  end

  subject { described_class.new(tribunal_case) }

  describe '.new' do
    it 'accepts a tribunal case' do
      expect(subject.tribunal_case).to eq(tribunal_case)
    end
  end

  describe '#call!' do
    let(:glimr_response_double) {
      instance_double(
        GlimrApiClient::RegisterNewCase,
        response_body: {
        tribunalCaseNumber: 'TC/12345',
        confirmationCode: 'ABCDEF'
      }
      )
    }

    # TODO: add all the params once we know what to send
    let(:glimr_params) do
      {
        jurisdictionId: 8,
        onlineMappingCode: 'APPEAL_PENALTY_LOW',
        documentsURL: 'http://downloader.dsd.io/d29210a8-f2fe-4d6f-ac96-ea4f9fd66687',
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
          expect(subject.call!).to be_an_instance_of(described_class)
        end

        it 'retrieves the tc_number and conf_code' do
          subject.call!
          expect(subject.case_reference).to eq('TC/12345')
          expect(subject.confirmation_code).to eq('ABCDEF')
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

      context 'when taxpayer_type is company' do
        let(:taxpayer_type) { ContactableEntityType::COMPANY }
        let(:organisation_params) {
          glimr_params.except(:contactFirstName, :contactLastName).merge(
            contactOrganisationName: 'Company Name', contactFAO: 'Destany Fritsch')
        }

        it 'sends required organisation params but not individual params' do
          expect(GlimrApiClient::RegisterNewCase).to receive(:call).
            with(hash_including(organisation_params)).and_return(glimr_response_double)
          subject.call!
        end
      end
    end

    describe 'Error cases' do
      before do
        allow(tribunal_case).to receive(:mapping_code).and_return(MappingCode::APPEAL_PENALTY_LOW)
      end

      # The original spec positied a nil response body from GlimrApiClient.
      # Although there are currently some edge cases (see
      # https://www.pivotaltracker.com/story/show/140766861), this should not
      # acutally happen.  Instead, it should raise a
      # GlimrApiClient::Unavailable exception.
      context 'GlimrApiClient::Unavailable' do
        before do
          allow(GlimrApiClient::RegisterNewCase).to receive(:call).and_raise(GlimrApiClient::Unavailable)
        end

        it 'is trapped' do
          expect { subject.call! }.not_to raise_exception
        end

        it 'is logged' do
          expect(Rails.logger).to receive(:info)
          subject.call!
        end

        it 'marks the case as submitted' do
          expect { subject.call! }.to change { tribunal_case.case_status }.to(CaseStatus::SUBMITTED)
        end
      end

      context 'Other Errors' do
        before do
          allow(GlimrApiClient::RegisterNewCase).to receive(:call).and_raise(NoMethodError)
        end

        it 'is not trapped' do
          expect { subject.call! }.to raise_exception(NoMethodError)
        end

        it 'is logged' do
          expect(Rails.logger).to receive(:info)
          expect { subject.call! }.to raise_exception(NoMethodError)
        end

        it 'does not mark the case as submitted' do
          expect { subject.call! }.to raise_exception(NoMethodError).and not_change(tribunal_case, :case_status)
        end
      end
    end
  end
end
