require 'rails_helper'

RSpec.describe DocumentUploadHelper do
  let(:tribunal_case) { double(TribunalCase, files_collection_ref: 'r3f3r3nc3') }
  let(:form) { double('Form object') }

  before do
    allow(helper).to receive(:current_tribunal_case).and_return(tribunal_case)
    allow(tribunal_case).to receive(:[]).with(:some_step_file_name).and_return(file_name)
  end

  describe '#document_upload_field' do
    subject { helper.document_upload_field(form, :some_step, label_text: 'A file') }

    context 'when there is no document uploaded' do
      let(:file_name) { nil }

      it 'renders the upload field' do
        expect(helper).to receive(:render).with(
          partial: 'steps/shared/document_upload/document_upload_field',
          locals: {
            form:       form,
            field_name: :some_step_document,
            label_text: 'A file'
          }
        )
        subject
      end
    end

    context 'when there is an uploaded document' do
      let(:file_name) { 'shopping_list.pdf' }

      it { is_expected.to be_nil }
    end
  end

  describe '#display_current_document' do
    subject { helper.display_current_document(:some_step) }

    context 'when there is no document uploaded' do
      let(:file_name) { nil }

      it { is_expected.to be_nil }
    end

    context 'when there is an uploaded document' do
      let(:file_name) { 'shopping_list.pdf' }
      let(:document) { instance_double(Document) }

      it 'renders the uploaded document partial' do
        expect(Document).to receive(:new).with(
          collection_ref: 'r3f3r3nc3',
          name: 'shopping_list.pdf'
        ).and_return(document)

        expect(helper).to receive(:render).with(
          partial: 'steps/shared/document_upload/current_document',
          locals: {
            current_document: document
          }
        )
        subject
      end
    end
  end
end
