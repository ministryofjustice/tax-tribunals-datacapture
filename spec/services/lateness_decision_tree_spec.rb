require 'spec_helper'

RSpec.describe LatenessDecisionTree do
  let(:tribunal_case) { double('TribunalCase') }
  let(:step_params)   { double('Step') }
  let(:next_step)     { nil }
  subject { described_class.new(tribunal_case: tribunal_case, step_params: step_params, next_step: next_step) }

  describe '#destination' do
    context 'when the step is `in_time`' do
      context 'and the answer is `yes`' do
        let(:step_params) { { in_time: 'yes' } }

        # TODO: Change this to point at the first step in the repellant flow
        # ('./who_are_you' in the prototype) when that is merged in.
        it { is_expected.to have_destination('/steps/details/taxpayer_type', :edit) }
      end

      context 'and the answer is `no`' do
        let(:step_params) { { in_time: 'no' } }

        it { is_expected.to have_destination(:lateness_reason, :edit) }
      end

      context 'and the answer is `unsure`' do
        let(:step_params) { { in_time: 'unsure' } }

        it { is_expected.to have_destination(:lateness_reason, :edit) }
      end
    end

    context 'when the step is `lateness_reason`' do
      let(:step_params) { { lateness_reason: 'anything' } }

      it { is_expected.to have_destination('/task_list', :index) }
    end

    context 'when the step is invalid' do
      let(:step_params) { { ungueltig: { waschmaschine: 'nein' } } }

      it 'raises an error' do
        expect { subject.destination }.to raise_error(RuntimeError)
      end
    end
  end

  describe '#previous' do
    context 'when the step is `in_time`' do
      let(:step_params) { { in_time: 'anything' } }

      it { is_expected.to have_previous(:start, :show) }
    end

    context 'when the step is `lateness_reason`' do
      let(:step_params) { { lateness_reason: 'anything' } }

      it { is_expected.to have_previous(:in_time, :edit) }
    end

    context 'when the step is invalid' do
      let(:step_params) { { ungueltig: { waschmaschine: 'nein' } } }

      it 'raises an error' do
        expect { subject.previous }.to raise_error(RuntimeError)
      end
    end
  end
end
