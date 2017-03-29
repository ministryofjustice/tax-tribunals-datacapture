require 'spec_helper'

module CheckAnswers
  describe FileOrTextAnswer do
    let(:question) { 'Question?' }
    let(:value) { 'Answer!' }
    let(:file) { nil }
    let(:change_path) { nil }

    subject { described_class.new(question, value, file, change_path: change_path) }

    describe '#show?' do
      context 'when no value or file is given' do
        let(:value) { nil }
        let(:file) { nil }

        it 'returns false' do
          expect(subject.show?).to eq(false)
        end
      end

      context 'when no value is given' do
        let(:value) { 'hello' }
        let(:file) { nil }

        it 'returns true' do
          expect(subject.show?).to eq(true)
        end
      end

      context 'when file is given' do
        let(:value) { nil }
        let(:file) { double('file') }

        it 'returns true' do
          expect(subject.show?).to eq(true)
        end
      end
    end

    describe '#to_partial_path' do
      it 'returns the correct partial path' do
        expect(subject.to_partial_path).to eq('file_or_text_row')
      end
    end
  end
end
