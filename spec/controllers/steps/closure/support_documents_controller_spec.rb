require 'rails_helper'

RSpec.describe Steps::Closure::SupportDocumentsController, type: :controller do
  before do
    allow(controller).to receive(:current_tribunal_case).and_return(tribunal_case)
    allow(tribunal_case).to receive(:documents).with(:supporting_documents).and_return([document])
  end

  let(:tribunal_case) { TribunalCase.new }
  let(:document) { Document.new(title: 'test.doc', collection_ref: '123') }

  it_behaves_like 'an intermediate step controller', Steps::Closure::SupportDocumentsForm, TaxTribs::ClosureDecisionTree

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
