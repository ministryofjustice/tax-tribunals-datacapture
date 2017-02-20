require 'rails_helper'

include ActionDispatch::TestProcess

RSpec.describe DocumentsController, type: :controller do

  let(:collection_ref) { '12345' }
  let(:filename) { 'dGVzdCBmaWxlLnR4dA==\n' } # 'test file.txt' - base64 encoded
  let(:another_filename) { 'YW5vdGhlcg==\n' } # 'another' - base64 encoded
  let(:current_tribunal_case) {
    instance_double(
      TribunalCase,
      grounds_for_appeal_file_name: 'test file.txt',
      files_collection_ref: collection_ref,
      case_status: nil
    )
  }
  let(:file) { fixture_file_upload('files/image.jpg', 'image/jpeg') }

  let(:upload_response) { double(code: 200, body: {}, error?: false) }

  before do
    allow(subject).to receive(:current_tribunal_case).and_return(current_tribunal_case)
    allow(MojFileUploaderApiClient::AddFile).to receive(:new).and_return(double(call: upload_response))
    session[:current_step_path] = 'step/to/redirect'
  end

  include_examples 'checks the validity of the current tribunal case on create'

  describe '#create' do
    let(:format) { :html }

    before do
      post :create, params: {document: file}, format: format
    end

    context 'document is valid' do
      context 'HTML format' do
        it 'should create the document and redirect back to the step' do
          expect(subject).to redirect_to('step/to/redirect')
          expect(flash.alert).to be_nil
        end
      end

      context 'JSON format' do
        let(:format) { :json }

        it 'should create the document and respond with a document_upload json object' do
          expect(response.status).to eq(201)
          expect(response.body).to eq('{"name":"image.jpg","encoded_name":"aW1hZ2UuanBn\n","collection_ref":"12345"}')
        end
      end
    end

    context 'document is valid but there were upload errors' do
      let(:upload_response) { double(code: 500, body: {}, error?: true) }

      context 'HTML format' do
        it 'should create the document and redirect back to the step' do
          expect(subject).to redirect_to('step/to/redirect')
          expect(flash.alert).not_to be_empty
        end
      end

      context 'JSON format' do
        let(:format) { :json }

        it 'should respond with an error object' do
          expect(response.status).to eq(422)
          res = JSON.parse(response.body)
          expect(res).to have_key('error')
        end
      end
    end

    context 'document is not valid' do
      let(:file) { fixture_file_upload('files/image.jpg', 'application/zip') }

      context 'HTML format' do
        it 'should create the document and redirect back to the step' do
          expect(subject).to redirect_to('step/to/redirect')
          expect(flash.alert).not_to be_empty
        end
      end

      context 'JSON format' do
        let(:format) { :json }

        it 'should respond with an error object' do
          expect(response.status).to eq(422)
          res = JSON.parse(response.body)
          expect(res).to have_key('error')
        end
      end
    end
  end

  include_examples 'checks the validity of the current tribunal case on destroy'

  describe '#destroy' do
    context 'deleting a different document to the grounds_for_appeal document' do
      let(:params) {
        {id: another_filename}
      }

      before do
        expect(MojFileUploaderApiClient::DeleteFile).to receive(:new).with(
            collection_ref: collection_ref, filename: 'another').and_return(double(call: true))

        expect(current_tribunal_case).not_to receive(:update).with(grounds_for_appeal_file_name: nil)
      end

      context 'HTML format' do
        it 'should delete the file and redirect to the documents_checklist step' do
          delete :destroy, params: params
          expect(subject).to redirect_to('step/to/redirect')
        end
      end

      context 'JSON format' do
        it 'should respond with an empty body and success status code' do
          delete :destroy, params: params, format: :json
          expect(response.status).to eq(204)
          expect(response.body).to eq('')
        end
      end
    end

    context 'deleting the grounds_for_appeal document' do
      let(:params) {
        {id: filename}
      }

      before do
        expect(MojFileUploaderApiClient::DeleteFile).to receive(:new).with(
            collection_ref: collection_ref, filename: 'test%20file.txt').and_return(double(call: true))

        expect(current_tribunal_case).to receive(:update).with(grounds_for_appeal_file_name: nil)
      end

      context 'HTML format' do
        it 'should nil the document name and redirect to the same step' do
          delete :destroy, params: params
          expect(subject).to redirect_to('step/to/redirect')
        end
      end

      context 'JSON format' do
        it 'should respond with an empty body and success status code' do
          delete :destroy, params: params, format: :json
          expect(response.status).to eq(204)
          expect(response.body).to eq('')
        end
      end
    end
  end
end
