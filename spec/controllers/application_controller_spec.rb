require 'spec_helper'

RSpec.describe ApplicationController, type: :controller do
  let(:tribunal_case) {
    instance_double(TribunalCase,
                    grounds_for_appeal_file_name: grounds_for_appeal_file_name,
                    files_collection_ref: files_collection_ref)
  }
  let(:grounds_for_appeal_file_name) { 'test.doc' }
  let(:files_collection_ref) { '12345' }

  before do
    allow(subject).to receive(:current_tribunal_case).and_return(tribunal_case)
  end

  describe '#current_grounds_for_appeal_document' do
    it 'return a Document object for the current grounds_for_appeal filename' do
      document = subject.current_grounds_for_appeal_document
      expect(document).not_to be_nil
      expect(document.name).to eq(grounds_for_appeal_file_name)
      expect(document.collection_ref).to eq(files_collection_ref)
    end
  end

  describe '#current_files_collection_ref' do
    it 'gets the collection_ref from the current tribunal case' do
      expect(subject.current_files_collection_ref).to eq(files_collection_ref)
    end
  end
end
