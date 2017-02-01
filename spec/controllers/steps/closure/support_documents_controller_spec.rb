require 'rails_helper'

RSpec.describe Steps::Closure::SupportDocumentsController, type: :controller do
  let(:uploaded_files) { {collection: '12345', files: [
    {key: '12345/test.doc', title: 'test.doc', last_modified: '2016-12-05T12:20:02.000Z'},
  ]} }
  let(:response_double) { instance_double(MojFileUploaderApiClient::Response, code: 200, body: uploaded_files) }

  before do
    allow(MojFileUploaderApiClient::ListFiles).to receive(:new).and_return(double(call: response_double))
  end

  it_behaves_like 'an intermediate step controller', Steps::Closure::SupportDocumentsForm, ClosureDecisionTree

  describe '#edit' do
    let!(:existing_case) { TribunalCase.create }

    it 'assigns previously uploaded files' do
      get :edit, session: { tribunal_case_id: existing_case.id }

      documents = assigns[:document_list]
      expect(documents.size).to eq(1)
      expect(documents.first.name).to eq('test.doc')
    end
  end
end
