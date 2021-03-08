require 'spec_helper'

module CheckAnswers
  describe AppealSectionPresenter do
    subject { described_class.new(tribunal_case) }
    let(:tribunal_case) { TribunalCase.new(case_type: case_type, dispute_type: dispute_type) }
    let(:case_type) { CaseType.new(:something) }
    let(:dispute_type) { CaseType.new(:something) }

    let(:answer) { instance_double(Answer, show?: true) }
    let(:number_of_answers) { 7 }

    before do
      allow(tribunal_case).to receive(:documents).and_return([])
      allow(Answer).to receive(:new).and_return(answer)
    end

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:appeal)
      end
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(subject.answers.count).to eq(number_of_answers)

        expect(subject.answers[0]).to eq(answer)
        expect(subject.answers[1]).to eq(answer)
        expect(subject.answers[2]).to eq(answer)
        expect(subject.answers[3]).to eq(answer)
        expect(subject.answers[4]).to eq(answer)
        expect(subject.answers[5]).to eq(answer)
      end

      context 'when the case type is other' do
        let(:case_type) { CaseType::OTHER }

        it 'has the correct rows' do
          expect(subject.answers.count).to eq(number_of_answers)

          expect(subject.answers[0]).to eq(answer)
          expect(subject.answers[1]).to eq(answer)
          expect(subject.answers[2]).to eq(answer)
          expect(subject.answers[3]).to eq(answer)
          expect(subject.answers[4]).to eq(answer)
          expect(subject.answers[5]).to eq(answer)
        end
      end

      context 'when the dispute type is other' do
        let(:dispute_type) { DisputeType::OTHER }

        it 'has the correct rows' do
          expect(subject.answers.count).to eq(number_of_answers)

          expect(subject.answers[0]).to eq(answer)
          expect(subject.answers[1]).to eq(answer)
          expect(subject.answers[2]).to eq(answer)
          expect(subject.answers[3]).to eq(answer)
          expect(subject.answers[4]).to eq(answer)
          expect(subject.answers[5]).to eq(answer)
        end
      end

      context 'when the penalty amount is not blank' do
        let(:dispute_type) { DisputeType::PENALTY }
        let(:tribunal_case) {
          TribunalCase.new(case_type: case_type, dispute_type: dispute_type, penalty_amount: '1234')
        }

        it 'has the correct rows' do
          expect(subject.answers.count).to eq(number_of_answers)
        end
      end
    end
  end
end
