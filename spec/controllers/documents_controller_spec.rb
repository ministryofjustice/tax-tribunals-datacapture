require 'rails_helper'

include ActionDispatch::TestProcess

RSpec.describe DocumentsController, type: :controller do

  let(:collection_ref) { '12345' }
  let(:filename) { 'dGVzdA==\n' } # 'test' - base64 encoded
  let(:another_filename) { 'YW5vdGhlcg==\n' } # 'another' - base64 encoded
  let(:current_tribunal_case) { instance_double(TribunalCase, grounds_for_appeal_file_name: 'test') }

  let(:upload_valid) { true }
  let(:upload_errors) { nil }
  let(:upload_result) { double(error?: false) }
  let(:upload_double) { instance_double(DocumentUpload, upload!: upload_result, valid?: upload_valid, errors: upload_errors) }

  before do
    allow(subject).to receive(:current_files_collection_ref).and_return(collection_ref)
  end

  describe '#create' do
    let(:headers) { {'HTTP_REFERER': edit_steps_details_documents_checklist_path} }

    before do
      request.headers.merge!(headers)
      expect(DocumentUpload).to receive(:new).with('file').and_return(upload_double)
    end

    context 'document is valid' do
      it 'should create the document and redirect back to the step' do
        post :create, params: {document: 'file'}
        expect(subject).to redirect_to(edit_steps_details_documents_checklist_path)
        expect(flash.alert).to be_nil
      end
    end

    context 'document is valid but there were upload errors' do
      let(:upload_valid) { true }
      let(:upload_result) { double(error?: true) }

      it 'should create the document and redirect back to the step' do
        post :create, params: {document: 'file'}
        expect(subject).to redirect_to(edit_steps_details_documents_checklist_path)
        expect(flash.alert).to eq('There was an error uploading the file. Please try again.')
      end
    end

    context 'document is not valid' do
      let(:upload_valid) { false }
      let(:upload_errors) { [:file_size] }

      it 'should create the document and redirect back to the step' do
        post :create, params: {document: 'file'}
        expect(subject).to redirect_to(edit_steps_details_documents_checklist_path)
        expect(flash.alert).to eq('There were errors: [:file_size]')
      end
    end
  end

  describe '#destroy' do
    let(:headers) { {'HTTP_REFERER': edit_steps_details_documents_checklist_path} }

    before do
      request.headers.merge!(headers)
      expect(subject).to receive(:current_tribunal_case).at_least(:once).and_return(current_tribunal_case)
    end

    context 'deleting a different document to the grounds_for_appeal document' do
      let(:params) {
        {id: another_filename}
      }

      before do
        expect(MojFileUploaderApiClient::DeleteFile).to receive(:new).with(
            collection_ref: collection_ref, filename: 'another').and_return(double(call: true))

        expect(current_tribunal_case).not_to receive(:update).with(grounds_for_appeal_file_name: nil)
      end

      it 'should delete the file and redirect to the documents_checklist step' do
        delete :destroy, params: params
        expect(subject).to redirect_to(edit_steps_details_documents_checklist_path)
      end
    end

    context 'deleting the grounds_for_appeal document' do
      let(:params) {
        {id: filename}
      }

      let(:headers) { {'HTTP_REFERER': edit_steps_details_grounds_for_appeal_path} }

      before do
        expect(MojFileUploaderApiClient::DeleteFile).to receive(:new).with(
            collection_ref: collection_ref, filename: 'test').and_return(double(call: true))

        expect(current_tribunal_case).to receive(:update).with(grounds_for_appeal_file_name: nil)
      end

      it 'should nil the document name and redirect to the same step' do
        delete :destroy, params: params
        expect(subject).to redirect_to(edit_steps_details_grounds_for_appeal_path)
      end
    end
  end
end
