require 'spec_helper'

RSpec.describe LatenessDecisionTree do
  let(:object)    { double('Object') }
  let(:step)      { double('Step') }
  let(:next_step) { nil }
  subject { described_class.new(object: object, step: step, next_step: next_step) }

  describe '#destination' do
    context 'when the step is `in_time`' do
      context 'and the answer is `yes`' do
        let(:step) { { in_time: 'yes' } }

        it 'sends the user to the task list' do
          expect(subject.destination).to eq({
            controller: '/home',
            action:     :index
          })
        end
      end

      context 'and the answer is `no`' do
        let(:step) { { in_time: 'no' } }

        it 'sends the user to the `lateness_reason` step' do
          expect(subject.destination).to eq({
            controller: :lateness_reason,
            action:     :edit
          })
        end
      end

      context 'and the answer is `unsure`' do
        let(:step) { { in_time: 'unsure' } }

        it 'sends the user to the `lateness_reason` step' do
          expect(subject.destination).to eq({
            controller: :lateness_reason,
            action:     :edit
          })
        end
      end
    end

    context 'when the step is `lateness_reason`' do
      let(:step) { { lateness_reason: 'anything' } }

      it 'sends the user to the home page' do
        expect(subject.destination).to eq({
          controller: '/home',
          action:     :index
        })
      end
    end

    context 'when the step is invalid' do
      let(:step) { { ungueltig: { waschmaschine: 'nein' } } }

      it 'raises an error' do
        expect { subject.destination }.to raise_error(RuntimeError)
      end
    end
  end
end
