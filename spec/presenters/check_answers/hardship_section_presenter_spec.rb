require 'spec_helper'

module CheckAnswers
  describe HardshipSectionPresenter do
    subject { described_class.new(tribunal_case) }
    let(:tribunal_case) { TribunalCase.new(disputed_tax_paid: disputed_tax_paid) }
    let(:disputed_tax_paid) { nil }

    let(:answer) { instance_double(Answer, show?: true) }
    let(:file_or_text_answer) { instance_double(FileOrTextAnswer, show?: true) }

    before do
      allow(tribunal_case).to receive(:documents).and_return([])

      allow(Answer).to receive(:new).and_return(answer)
      allow(FileOrTextAnswer).to receive(:new).and_return(file_or_text_answer)
    end

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:hardship)
      end
    end

    describe '#show' do
      context 'when hardship applies' do
        let(:disputed_tax_paid) { DisputedTaxPaid::YES }

        it 'returns true' do
          expect(subject.show?).to eq(true)
        end
      end

      context 'when hardship does not apply' do
        let(:disputed_tax_paid) { nil }

        it 'returns false' do
          expect(subject.show?).to eq(false)
        end
      end
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(subject.answers.count).to eq(4)

        expect(subject.answers[0]).to eq(answer)
        expect(subject.answers[1]).to eq(answer)
        expect(subject.answers[2]).to eq(answer)
        expect(subject.answers[3]).to eq(file_or_text_answer)
      end
    end
  end
end
