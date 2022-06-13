require 'rails_helper'

include ActionDispatch::TestProcess

RSpec.describe DocumentsController, type: :controller do
  let(:collection_ref) { '12345' }
  let(:document_key) { 'some_step' }
  let(:filename) { 'dGVzdCBmaWxlLnR4dA==\n' } # 'test file.txt' - base64 encoded
  let(:another_filename) { 'YW5vdGhlcg==\n' } # 'another' - base64 encoded
  let(:current_tribunal_case) {
    instance_double(
      TribunalCase,
      files_collection_ref: collection_ref,
      case_status: nil
    )
  }
  let(:file) { fixture_file_upload('files/image.jpg', 'image/jpeg') }

  let(:document_upload) { instance_double(DocumentUpload, upload!: {}, valid?: true, errors?: false, to_hash: {name: 'image.jpg', encoded_name: "aW1hZ2UuanBn\n", collection_ref: '12345'}) }

  before do
    allow(subject).to receive(:current_tribunal_case).and_return(current_tribunal_case)
    allow(DocumentUpload).to receive(:new).and_return(document_upload)
    session[:current_step_path] = 'step/to/redirect'
  end

  include_examples 'checks the validity of the current tribunal case on create', { document_key: :foo_bar }

  describe '#create' do
    let(:format) { :html }

    before do
      local_post :create, params: {document: file, document_key: 'foo'}, format: format
    end

    context 'document is valid' do
      let(:document_upload) { instance_double(DocumentUpload, upload!: {}, valid?: true, errors?: false, to_hash: {name: 'image.jpg', encoded_name: "aW1hZ2UuanBn\n", collection_ref: '12345'}) }

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
      let(:document_upload) { instance_double(DocumentUpload, upload!: {}, valid?: true, errors?: true, errors: ["You're doing it wrong"]) }

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
      let(:document_upload) { instance_double(DocumentUpload, upload!: {}, valid?: false, errors?: true, errors: ["You're doing it wrong"]) }

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

  include_examples 'checks the validity of the current tribunal case on destroy', { document_key: :foo_bar }

  describe '#destroy' do
    context 'response formats' do
      let(:params) { {
        document_key: 'supporting_documents',
        id: another_filename
      } }

      before do
        expect(Uploader).to receive(:delete_file).with(collection_ref: collection_ref, document_key: 'supporting_documents', filename: 'another').and_return({})
      end

      context 'HTML format' do
        it 'should delete the file and redirect to the step' do
          local_delete :destroy, params: params
          expect(subject).to redirect_to('step/to/redirect')
        end
      end

      context 'JSON format' do
        it 'should respond with an empty body and success status code' do
          local_delete :destroy, params: params, format: :json
          expect(response.status).to eq(204)
          expect(response.body).to eq('')
        end
      end
    end

    context 'URI encode square brackets', focus: true do
      let(:filename) {'file [name].txt'}
      let(:base64_filename) { Base64.encode64(filename) }

      it 'encode square brackets' do
        expect(Uploader).to receive(:delete_file).with(hash_including(filename: 'file%20%5Bname%5D%2Etxt'))
        local_delete :destroy, params: {document_key: 'test', id: base64_filename}
      end
    end
  end
end
