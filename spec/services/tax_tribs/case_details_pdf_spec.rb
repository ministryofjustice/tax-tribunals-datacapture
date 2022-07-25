require 'spec_helper'

RSpec.describe TaxTribs::CaseDetailsPdf do
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
      AppealCasesController,
      pdf_template: 'show_this',
      render_to_string: 'this is a pdf',
      current_tribunal_case: tribunal_case,
      class: double(name: 'AppealCasesController')
    )
  }
  let(:presenter) { instance_double(CheckAnswers::AnswersPresenter, pdf_filename: 'TC_2016_12345_FirstnameLastname') }
  let(:uploader_double) { instance_double(DocumentUpload, upload!: true) }

  subject { described_class.new(tribunal_case, controller_ctx, presenter) }

  describe '#generate' do
    it 'should generate the PDF' do
      expect(controller_ctx).to receive(:render_to_string).with(
        formats: [:pdf],
        pdf: true,
        encoding: 'UTF-8',
        template: 'show_this'
      )
      subject.generate
      expect(subject.pdf).not_to be_nil
    end
  end

  describe '#generate_and_upload' do
    it 'calls generate' do
      expect(subject).to receive(:generate)
      subject.generate_and_upload
    end

    it 'calls upload' do
      expect(subject).to receive(:upload)
      subject.generate_and_upload
    end
  end

  # Using send() to test a private method in order to address mutations arising
  # in this specific method. This way we don't need to test the whole chain.
  describe '.upload' do
    before do
      allow(DocumentUpload).to receive(:new).and_return(uploader_double)
      allow(uploader_double).to receive(:valid?).and_return(true)
      allow(uploader_double).to receive(:errors?).and_return(false)
    end

    it 'writes the generated PDF string to a tempfile' do
      allow(subject).to receive(:pdf).and_return('my pdf')
      expect(File).to receive(:binwrite).with(File, 'my pdf')
      subject.send(:upload)
    end

    it 'instantiates DocumentUpload with the correct values' do
      expect(DocumentUpload).to receive(:new).with(
        an_instance_of(File),
        document_key: :case_details,
        filename: 'TC_2016_12345_FirstnameLastname.pdf',
        content_type: 'application/pdf',
        collection_ref: 'd29210a8-f2fe-4d6f-ac96-ea4f9fd66687'
      )
      subject.send(:upload)
    end

    context 'success' do
      it 'checks validity of uploader' do
        expect(uploader_double).to receive(:valid?)
        subject.send(:upload)
      end

      it 'should generate the PDF and upload it' do
        expect(uploader_double).to receive(:upload!)
        subject.send(:upload)
      end
    end

    context 'failure' do
      before do
        allow(uploader_double).to receive(:errors?).and_return(true)
      end

      it 'raises an exception' do
        allow(uploader_double).to receive(:errors)
        expect { subject.send(:upload) }.to raise_error(described_class::UploadError)
      end

      it 'sets the error backtrace on the exception' do
        expect(uploader_double).to receive(:errors)
        subject.send(:upload) rescue described_class::UploadError
      end
    end
  end
end
