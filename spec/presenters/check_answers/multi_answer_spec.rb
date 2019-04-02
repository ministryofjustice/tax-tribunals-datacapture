require 'spec_helper'

module CheckAnswers
  describe MultiAnswer do
    let(:question) { 'Question?' }
    let(:value) { [:support, :assist, :other, 'Some text'] }
    let(:change_path) { nil }


    subject { described_class.new(question, value, change_path: change_path) }

    describe '#show?' do
      context 'when no value is given' do
        let(:value) { nil }

        it 'returns false' do
          expect(subject.show?).to eq(false)
        end
      end

      context 'when value is given' do
        it 'returns true' do
          expect(subject.show?).to eq(true)
        end
      end
    end

    describe '#to_partial_path' do
      it 'returns the correct partial path' do
        expect(subject.to_partial_path).to eq('multi_answer_row')
      end
    end
  end
end
