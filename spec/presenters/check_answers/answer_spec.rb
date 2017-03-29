require 'spec_helper'

module CheckAnswers
  describe Answer do
    let(:question) { 'Question?' }
    let(:value) { 'Answer!' }
    let(:raw) { nil }
    let(:change_path) { nil }

    subject { described_class.new(question, value, raw: raw, change_path: change_path) }

    describe '#show?' do
      it 'returns true' do
        expect(subject.show?).to eq(true)
      end

      context 'when no value is given' do
        let(:value) { nil }

        it 'returns false' do
          expect(subject.show?).to eq(false)
        end
      end
    end

    describe '#value?' do
      it 'returns true' do
        expect(subject.value?).to eq(true)
      end

      context 'when no value is given' do
        let(:value) { nil }

        it 'returns false' do
          expect(subject.value?).to eq(false)
        end
      end
    end

    describe '#raw?' do
      it 'returns false' do
        expect(subject.raw?).to eq(false)
      end

      context 'when raw is given' do
        let(:raw) { true }

        it 'returns true' do
          expect(subject.raw?).to eq(true)
        end
      end
    end

    describe '#show_change_link?' do
      it 'returns false' do
        expect(subject.show_change_link?).to eq(false)
      end

      context 'when change_path is given' do
        let(:change_path) { '/change' }

        it 'returns true' do
          expect(subject.show_change_link?).to eq(true)
        end
      end
    end

    describe '#to_partial_path' do
      it 'returns the correct partial path' do
        expect(subject.to_partial_path).to eq('row')
      end
    end
  end
end
