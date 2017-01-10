require 'spec_helper'

RSpec.describe CaseDetailsPdf do
  let!(:tribunal_case) { TribunalCase.create(case_attributes) }
  let(:controller_ctx) { CaseDetailsController.new }

  let(:taxpayer_type) { TaxpayerType::INDIVIDUAL }
  let(:case_attributes) do
    {
      taxpayer_type: taxpayer_type,
      taxpayer_individual_name: 'Individual Name',
      taxpayer_company_name: 'Company Name',
      files_collection_ref: 'd29210a8-f2fe-4d6f-ac96-ea4f9fd66687',
    }
  end

  subject { described_class.new(tribunal_case, controller_ctx) }


  describe '#filename' do
    context 'when taxpayer is an individual' do
      let(:taxpayer_type) { TaxpayerType::INDIVIDUAL }

      it 'should include the individual name in the file name' do
        expect(subject.filename).to eq('TC_NUMBER_HMRC_IndividualName.pdf')
      end
    end

    context 'when taxpayer is a company' do
      let(:taxpayer_type) { TaxpayerType::COMPANY }

      it 'should include the company name in the file name' do
        expect(subject.filename).to eq('TC_NUMBER_HMRC_CompanyName.pdf')
      end
    end
  end

  describe '#generate' do
    it 'should generate the PDF' do
      expect(controller_ctx).to receive(:render_to_string).at_least(:once).and_call_original
      expect(subject.generate).to match(/%PDF/)
    end
  end

  describe '#generate_and_upload' do
    before do
      expect(controller_ctx).to receive(:render_to_string).and_return('rendered pdf')
      expect(DocumentUpload).to receive(:new).with(
        an_instance_of(File),
        filename: 'TC_NUMBER_HMRC_IndividualName.pdf',
        content_type: 'application/pdf',
        collection_ref: 'd29210a8-f2fe-4d6f-ac96-ea4f9fd66687'
      ).and_return(uploader_double)
    end

    context 'upload successful' do
      let(:uploader_double) { instance_double(DocumentUpload, valid?: true, errors?: false, upload!: true) }

      it 'should generate the PDF and upload it' do
        expect(uploader_double).to receive(:upload!)
        subject.generate_and_upload
      end
    end

    context 'upload failed' do
      let(:uploader_double) { instance_double(DocumentUpload, valid?: true, errors?: true, upload!: true) }

      it 'should raise an exception' do
        expect { subject.generate_and_upload }.to raise_exception(Exception)
      end
    end
  end
end
