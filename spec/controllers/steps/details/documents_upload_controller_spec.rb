require 'rails_helper'

RSpec.describe Steps::Details::DocumentsUploadController, type: :controller do
  before do
    allow(controller).to receive(:current_tribunal_case).and_return(tribunal_case)
    allow(tribunal_case).to receive(:documents).with(:supporting_documents).and_return([document])
  end

  let(:tribunal_case) { TribunalCase.new }
  let(:document) { Document.new(title: 'test.doc', collection_ref: '123') }

  it_behaves_like 'an intermediate step controller', Steps::Details::DocumentsUploadForm, DetailsDecisionTree

  describe '#edit' do
    let!(:existing_case) { TribunalCase.create }

    it 'assigns previously uploaded files' do
      local_get :edit, session: { tribunal_case_id: existing_case.id }

      documents = assigns[:documents_list]
      expect(documents.size).to eq(1)
      expect(documents.first.name).to eq('test.doc')
    end
  end
end
