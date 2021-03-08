require 'spec_helper'

module CheckAnswers
  describe ClosureTypeSectionPresenter do
    subject { described_class.new(tribunal_case) }
    let(:tribunal_case) { TribunalCase.new }

    let(:answer) { instance_double(Answer, show?: true) }
    let(:number_of_answers) { 2 }

    before do
      allow(tribunal_case).to receive(:documents).and_return([])

      allow(Answer).to receive(:new).and_return(answer)
    end

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:closure_type)
      end
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(subject.answers.count).to eq(number_of_answers)

        expect(subject.answers[0]).to eq(answer)
      end
    end
  end
end
