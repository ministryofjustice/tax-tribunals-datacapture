require 'rails_helper'

include ActionDispatch::TestProcess

RSpec.describe DocumentsController, type: :controller do

  let(:collection_ref) { '12345' }
  let(:filename) { 'dGVzdA==\n' } # 'test' - base64 encoded
  let(:another_filename) { 'YW5vdGhlcg==\n' } # 'another' - base64 encoded
  let(:current_tribunal_case) { instance_double(TribunalCase, grounds_for_appeal_file_name: 'test', files_collection_ref: collection_ref) }
  let(:file) { fixture_file_upload('files/image.jpg', 'image/jpeg') }

  let(:upload_response) { double(code: 200, body: {}, error?: false) }

  before do
    allow(subject).to receive(:current_tribunal_case).and_return(current_tribunal_case)
    allow(MojFileUploaderApiClient::AddFile).to receive(:new).and_return(double(call: upload_response))
  end

  describe '#create' do
    let(:headers) { {'HTTP_REFERER': edit_steps_details_documents_checklist_path} }

    before do
      request.headers.merge!(headers)
      post :create, params: {document: file}
    end

    context 'document is valid' do
      it 'should create the document and redirect back to the step' do
        expect(subject).to redirect_to(edit_steps_details_documents_checklist_path)
        expect(flash.alert).to be_nil
      end
    end

    context 'document is valid but there were upload errors' do
      let(:upload_response) { double(code: 500, body: {}, error?: true) }

      it 'should create the document and redirect back to the step' do
        expect(subject).to redirect_to(edit_steps_details_documents_checklist_path)
        expect(flash.alert).to eq([:response_error])
      end
    end

    context 'document is not valid' do
      let(:file) { fixture_file_upload('files/image.jpg', 'application/zip') }

      it 'should create the document and redirect back to the step' do
        expect(subject).to redirect_to(edit_steps_details_documents_checklist_path)
        expect(flash.alert).to eq([:content_type])
      end
    end
  end

  describe '#destroy' do
    let(:headers) { {'HTTP_REFERER': edit_steps_details_documents_checklist_path} }

    before do
      request.headers.merge!(headers)
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
