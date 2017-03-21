require 'spec_helper'

module CheckAnswers
  describe LatenessSectionPresenter do
    subject { described_class.new(tribunal_case) }
    let(:tribunal_case) { TribunalCase.new }

    let(:answer) { instance_double(Answer, show?: true) }
    let(:file_or_text_answer) { instance_double(FileOrTextAnswer, show?: true) }

    before do
      allow(tribunal_case).to receive(:documents).and_return([])

      allow(Answer).to receive(:new).and_return(answer)
      allow(FileOrTextAnswer).to receive(:new).and_return(file_or_text_answer)
    end

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:lateness)
      end
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(subject.answers.count).to eq(2)

        expect(subject.answers[0]).to eq(answer)
        expect(subject.answers[1]).to eq(file_or_text_answer)
      end
    end
  end
end
