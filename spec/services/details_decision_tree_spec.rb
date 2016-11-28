require 'spec_helper'

RSpec.describe DetailsDecisionTree do
  let(:object)    { double('Object') }
  let(:step)      { double('Step') }
  let(:next_step) { nil }
  subject { described_class.new(object: object, step: step, next_step: next_step) }

  describe '#destination' do
    context 'when the step is `taxpayer_type`' do
      let(:step) { { taxpayer_type: 'anything_for_now'  } }

      it 'sends the user to the task list' do
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
