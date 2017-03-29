require 'spec_helper'

RSpec.describe CaseDetailsPdf do
  let(:tribunal_case) {
    TribunalCase.create(
      case_reference: 'TC/2016/12345',
      files_collection_ref: 'd29210a8-f2fe-4d6f-ac96-ea4f9fd66687',
      taxpayer_individual_first_name: 'Firstname',
      taxpayer_individual_last_name: 'Lastname'
    )
  }
  let(:controller_ctx) {
    double(
      ApplicationController,
      pdf_template: 'show_this',
      render_to_string: 'this is a pdf',
      current_tribunal_case: tribunal_case
    )
  }

  subject { described_class.new(tribunal_case, controller_ctx) }

  describe '#filename' do
    context 'for an organisation' do
      it 'should generate an appropriate file name' do
        expect(tribunal_case).to receive(:taxpayer_individual_first_name).and_return(nil)
        expect(tribunal_case).to receive(:taxpayer_individual_last_name).and_return(nil)
        expect(tribunal_case).to receive(:taxpayer_organisation_name).and_return('CPS')

        expect(subject.filename).to eq('TC_2016_12345_HMRC_CPS.pdf')
      end
    end

    context 'for an individual' do
      it 'should generate an appropriate file name' do
        expect(tribunal_case).to receive(:taxpayer_individual_first_name).and_return('Shirley')
        expect(tribunal_case).to receive(:taxpayer_individual_last_name).and_return('Schmidt')
        expect(tribunal_case).to receive(:taxpayer_organisation_name).and_return(nil)

        expect(subject.filename).to eq('TC_2016_12345_HMRC_ShirleySchmidt.pdf')
      end
    end
  end

  describe '#generate' do
    it 'should generate the PDF' do
      expect(controller_ctx).to receive(:render_to_string).with(hash_including(template: 'show_this'))
      subject.generate
    end
  end

  describe '#generate_and_upload' do
    before do
      expect(DocumentUpload).to receive(:new).with(
        an_instance_of(File),
        document_key: :case_details,
        filename: 'TC_2016_12345_HMRC_FirstnameLastname.pdf',
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
        expect { subject.generate_and_upload }.to raise_error
      end
    end
  end
end
