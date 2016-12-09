require 'rails_helper'

RSpec.describe GroundsForAppealHelper do
  let(:tribunal_case) {
    instance_double(TribunalCase,
                    grounds_for_appeal_file_name: grounds_for_appeal_file_name,
                    files_collection_ref: files_collection_ref)
  }
  let(:grounds_for_appeal_file_name) { 'test.doc' }
  let(:files_collection_ref) { '12345' }

  before do
    allow(helper).to receive(:current_tribunal_case).and_return(tribunal_case)
  end

  describe '#current_grounds_for_appeal_document' do
    it 'return a Document object for the current grounds_for_appeal filename' do
      document = helper.current_grounds_for_appeal_document
      expect(document).not_to be_nil
      expect(document.name).to eq(grounds_for_appeal_file_name)
      expect(document.collection_ref).to eq(files_collection_ref)
    end
  end
end
