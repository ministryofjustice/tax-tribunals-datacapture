require 'spec_helper'

module CheckAnswers
  describe DocumentsSubmittedAnswer do
    let(:question) { 'Question?' }
    let(:documents) { [] }
    let(:change_path) { nil }

    subject { described_class.new(question, documents, change_path: change_path) }

    describe '#to_partial_path' do
      it 'returns the correct partial path' do
        expect(subject.to_partial_path).to eq('documents_submitted_row')
      end
    end
  end
end
