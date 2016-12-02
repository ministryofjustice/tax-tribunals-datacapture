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

        it { is_expected.to have_destination('/home', :index) }
      end

      context 'and the answer is `no`' do
        let(:step) { { in_time: 'no' } }

        it { is_expected.to have_destination(:lateness_reason, :edit) }
      end

      context 'and the answer is `unsure`' do
        let(:step) { { in_time: 'unsure' } }

        it { is_expected.to have_destination(:lateness_reason, :edit) }
      end
    end

    context 'when the step is `lateness_reason`' do
      let(:step) { { lateness_reason: 'anything' } }

      it { is_expected.to have_destination('/home', :index) }
    end

    context 'when the step is invalid' do
      let(:step) { { ungueltig: { waschmaschine: 'nein' } } }

      it 'raises an error' do
        expect { subject.destination }.to raise_error(RuntimeError)
      end
    end
  end

  describe '#previous' do
    context 'when the step is `in_time`' do
      let(:step) { { in_time: 'anything' } }

      it { is_expected.to have_previous(:start, :show) }
    end

    context 'when the step is `lateness_reason`' do
      let(:step) { { lateness_reason: 'anything' } }

      it { is_expected.to have_previous(:in_time, :edit) }
    end

    context 'when the step is invalid' do
      let(:step) { { ungueltig: { waschmaschine: 'nein' } } }

      it 'raises an error' do
        expect { subject.previous }.to raise_error(RuntimeError)
      end
    end
  end
end
