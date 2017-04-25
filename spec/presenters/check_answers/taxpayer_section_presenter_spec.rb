require 'spec_helper'

module CheckAnswers
  describe TaxpayerSectionPresenter do
    subject { described_class.new(tribunal_case) }
    let(:tribunal_case) { TribunalCase.new(has_representative: has_representative) }
    let(:has_representative) { HasRepresentative::NO }

    let(:answer) { instance_double(Answer, show?: true) }
    let(:contact_details_answer) { instance_double(ContactDetailsAnswer, show?: true) }
    let(:file_or_text_answer) { instance_double(FileOrTextAnswer, show?: true) }

    before do
      allow(tribunal_case).to receive(:documents).and_return([])

      allow(Answer).to receive(:new).and_return(answer)
      allow(ContactDetailsAnswer).to receive(:new).and_return(contact_details_answer)
      allow(FileOrTextAnswer).to receive(:new).and_return(file_or_text_answer)
    end

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:taxpayer)
      end
    end

    describe '#show?' do
      context 'when the representative question have been answered' do
        it 'returns true' do
          expect(subject.show?).to eq(true)
        end
      end

      context 'when the representative question have not been answered' do
        let(:has_representative) { nil }
        let(:contact_details_answer) { instance_double(ContactDetailsAnswer, show?: false) }
        let(:file_or_text_answer) { instance_double(FileOrTextAnswer, show?: false) }
        let(:answer) { instance_double(Answer, show?: false) }

        it 'returns false' do
          expect(subject.show?).to eq(false)
        end
      end
    end

    describe '#answers' do
      context 'when there is a rep' do
        let(:has_representative) { HasRepresentative::YES }

        it 'has the correct rows' do
          expect(subject.answers.count).to eq(4)

          expect(subject.answers[0]).to eq(contact_details_answer)
          expect(subject.answers[1]).to eq(contact_details_answer)
          expect(subject.answers[2]).to eq(answer)
          expect(subject.answers[3]).to eq(file_or_text_answer)
        end
      end

      context 'when there is no rep' do
        let(:has_representative) { HasRepresentative::NO }

        it 'has the correct rows' do
          expect(subject.answers.count).to eq(4)

          expect(subject.answers[0]).to eq(contact_details_answer)
          expect(subject.answers[1]).to eq(answer)
          expect(subject.answers[2]).to eq(answer)
          expect(subject.answers[3]).to eq(file_or_text_answer)
        end
      end
    end
  end
end
