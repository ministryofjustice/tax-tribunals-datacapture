require 'spec_helper'

RSpec.describe TaxTribs::GlimrNewCase do
  let!(:tribunal_case)      { TribunalCase.create(case_attributes) }
  let(:has_representative)  { HasRepresentative::NO }
  let(:taxpayer_type)       { ContactableEntityType::INDIVIDUAL }
  let(:taxpayer_address)    { "769 Eleanore Landing\nSuite 225" }

  let(:case_attributes) do
    {
      case_type: CaseType::INCOME_TAX,
      taxpayer_type: taxpayer_type,
      taxpayer_individual_first_name: 'Filomena',
      taxpayer_individual_last_name: 'Keebler',
      taxpayer_contact_address: taxpayer_address,
      taxpayer_contact_postcode: 'SW1H 9AJ',
      taxpayer_contact_city: 'London',
      taxpayer_contact_country: 'UK',
      taxpayer_contact_phone: '0700 12345678',
      taxpayer_contact_email: 'test@example.com',
      taxpayer_organisation_name: 'Company Name',
      taxpayer_organisation_fao: 'Destany Fritsch',
      files_collection_ref: 'd29210a8-f2fe-4d6f-ac96-ea4f9fd66687',
      has_representative: has_representative
    }
  end

  subject { described_class.new(tribunal_case) }

  describe '.new' do
    it 'accepts a tribunal case' do
      expect(subject.tribunal_case).to eq(tribunal_case)
    end
  end

  describe '#call' do
    let(:glimr_response_double) {
      instance_double(
        GlimrApiClient::RegisterNewCase,
        response_body: {
          tribunalCaseNumber: 'TC/12345',
          confirmationCode: 'ABCDEF'
        }
      )
    }

    let(:glimr_params) do
      {
        jurisdictionId: 8,
        onlineMappingCode: 'APPN_OTHER',
        documentsURL: 'http://downloader.com/d29210a8-f2fe-4d6f-ac96-ea4f9fd66687',
        contactFirstName: 'Filomena',
        contactLastName: 'Keebler',
        contactStreet1: '769 Eleanore Landing',
        contactStreet2: 'Suite 225',
        contactPostalCode: 'SW1H 9AJ',
        contactCity: 'London',
        contactCountry: 'UK',
        contactPhone: '0700 12345678',
        contactEmail: 'test@example.com'
      }
    end

    before do
      allow(tribunal_case).to receive(:documents_url).and_return('http://downloader.com/d29210a8-f2fe-4d6f-ac96-ea4f9fd66687')
      expect(GlimrApiClient::RegisterNewCase).to receive(:call).
          with(glimr_params).and_return(glimr_response_double)
    end

    context 'registering the case into glimr' do
      it 'returns a TaxTribs::GlimrNewCase instance' do
        expect(subject.call).to be_an_instance_of(described_class)
      end

      it 'retrieves the tc_number and conf_code' do
        subject.call
        expect(subject.case_reference).to eq('TC/12345')
        expect(subject.confirmation_code).to eq('ABCDEF')
      end

      context 'when tribunalCaseNumber or confirmationCode are not returned' do
        let(:glimr_response_double) {
          instance_double(
            GlimrApiClient::RegisterNewCase,
            response_body: {}
          )
        }

        it 'returns a TaxTribs::GlimrNewCase instance' do
          expect(subject.call).to be_an_instance_of(described_class)
        end

        it 'logs the exception' do
          expect(Rails.logger).to receive(:info).with(
            "{\"caller\":\"TaxTribs::GlimrNewCase\",\"method\":\"call\",\"error\":\"key not found: :tribunalCaseNumber\"}"
          )
          subject.call
        end

        it 'sends the exception to Raven' do
          expect(Raven).to receive(:capture_exception).with(StandardError)
          subject.call
        end

        it 'returns as `nil` the case_reference and the confirmation_code' do
          subject.call
          expect(subject.case_reference).to be_nil
          expect(subject.confirmation_code).to be_nil
        end
      end
    end

    context 'when taxpayer_type is company' do
      let(:taxpayer_type) { ContactableEntityType::COMPANY }
      let(:glimr_params) {
        super().merge({
          contactOrganisationName: 'Company Name',
          contactFAO: 'Destany Fritsch'
        }).slice!(:contactFirstName, :contactLastName)
      }

      it { subject.call }
    end

    context 'lengthy addresses' do
      context 'several lines but less than 4' do
        let(:taxpayer_address) { "769 Eleanore Landing\nAnother street\nSuite 225" }
        let(:glimr_params) do
          super().merge({
            contactStreet1: '769 Eleanore Landing',
            contactStreet2: 'Another street',
            contactStreet3: 'Suite 225'
          })
        end

        it { subject.call }
      end

      context 'exceeding the 4 lines limit' do
        let(:taxpayer_address) { "769 Eleanore Landing\nAnother street\nSuite 225\nMore address\nEven more address" }
        let(:glimr_params) do
          super().merge({
            contactStreet1: '769 Eleanore Landing',
            contactStreet2: 'Another street',
            contactStreet3: 'Suite 225',
            contactStreet4: 'More address, Even more address'
          })
        end

        it { subject.call }
      end
    end

    context 'for a representative' do
      let(:case_attributes) do
        super().merge({
          has_representative: HasRepresentative::YES,
          representative_type: representative_type,
          representative_individual_first_name: 'Kraig',
          representative_individual_last_name: 'Walsh',
          representative_organisation_name: 'Cartwright-Rau',
          representative_organisation_fao: 'Wanda',
          representative_contact_phone: '12345',
          representative_contact_email: 'test-rep@example.com',
          representative_contact_address: "769 Eleanore Landing\nAnother street\nSuite 225\nMore address\nEven more address",
          representative_contact_postcode: 'X1 2YY',
          representative_contact_city: 'Manchester',
          representative_contact_country: 'United Kingdom'
        })
      end

      let(:glimr_params) do
        super().merge({
          repPhone: '12345',
          repEmail: 'test-rep@example.com',
          repPostalCode: 'X1 2YY',
          repCity: 'Manchester',
          repCountry: 'United Kingdom',
          repStreet1: '769 Eleanore Landing',
          repStreet2: 'Another street',
          repStreet3: 'Suite 225',
          repStreet4: 'More address, Even more address'
        })
      end

      context 'when representative_type is individual' do
        let(:representative_type) { ContactableEntityType::INDIVIDUAL }
        let(:glimr_params) do
          super().merge({
            repFirstName: 'Kraig',
            repLastName: 'Walsh'
          })
        end

        it {subject.call}

        # Mutant kill
        context 'for several lines addresses but less than 4' do
          let(:case_attributes) do
            super().merge({
              representative_contact_address: "769 Eleanore Landing\nAnother street\nSuite 225"
            })
          end
          let(:glimr_params) do
            super().slice!(:repStreet4)
          end

          it {subject.call}
        end
      end

      context 'when representative_type is company' do
        let(:representative_type) { ContactableEntityType::COMPANY }
        let(:glimr_params) {
          super().merge({
            repOrganisationName: 'Cartwright-Rau',
            repFAO: 'Wanda'
          })
        }

        it { subject.call }
      end
    end
  end

  describe 'Error cases' do
    # Right now we are capturing any kind of error that his call might produce, like timeouts,
    # or GlimrApiClient::Unavailable, and not showing the user the error, just silently sending it
    # to Raven and logging it, and also sending an email to the tribunal telling them there was a problem.
    context 'Any kind of error StandardError' do
      before do
        allow(GlimrApiClient::RegisterNewCase).to receive(:call).and_raise(StandardError)
      end

      it 'is trapped' do
        expect { subject.call }.not_to raise_exception
      end

      it 'is logged' do
        expect(Rails.logger).to receive(:info)
        subject.call
      end

      it 'is captured by Raven' do
        expect(Raven).to receive(:capture_exception)
        subject.call
      end
    end
  end
end
