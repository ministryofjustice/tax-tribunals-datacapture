require 'spec_helper'

module CheckAnswers
  describe DetailsSectionPresenter do
    subject { described_class.new(tribunal_case) }
    let(:tribunal_case) { TribunalCase.new(letter_upload_type: letter_upload_type) }
    let(:letter_upload_type) { nil }

    let(:documents_submitted_answer) { instance_double(DocumentsSubmittedAnswer, show?: true) }
    let(:file_or_text_answer) { instance_double(FileOrTextAnswer, show?: true) }
    let(:answer) { instance_double(Answer, show?: true) }

    before do
      allow(tribunal_case).to receive(:documents).and_return([])
      allow(FileOrTextAnswer).to receive(:new).and_return(file_or_text_answer)
      allow(Answer).to receive(:new).and_return(answer)
    end

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:details)
      end
    end

    describe '#answers' do
      context 'for a single letter file upload' do
        before do
          allow(DocumentsSubmittedAnswer).to receive(:new).with(
            :letter_uploaded, [], change_path: '/steps/details/letter_upload'
          ).and_return(documents_submitted_answer)
        end

        it 'has the correct rows' do
          expect(subject.answers.count).to eq(4)

          expect(subject.answers[0]).to eq(file_or_text_answer)
          expect(subject.answers[1]).to eq(file_or_text_answer)
          expect(subject.answers[2]).to eq(documents_submitted_answer)
          expect(subject.answers[3]).to eq(answer)
        end
      end

      context 'for a multi letter files upload' do
        let(:letter_upload_type) { LetterUploadType::MULTIPLE }

        before do
          allow(DocumentsSubmittedAnswer).to receive(:new).with(
            :letter_uploaded, [], change_path: '/steps/details/documents_upload'
          ).and_return(documents_submitted_answer)
        end

        it 'has the correct rows' do
          expect(subject.answers.count).to eq(4)

          expect(subject.answers[0]).to eq(file_or_text_answer)
          expect(subject.answers[1]).to eq(file_or_text_answer)
          expect(subject.answers[2]).to eq(documents_submitted_answer)
          expect(subject.answers[3]).to eq(answer)
        end
      end
    end
  end
end
