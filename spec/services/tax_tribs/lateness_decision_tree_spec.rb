require 'spec_helper'

RSpec.describe TaxTribs::LatenessDecisionTree do
  let(:tribunal_case) { double('TribunalCase') }
  let(:step_params)   { double('Step') }
  let(:next_step)     { nil }
  subject { described_class.new(tribunal_case: tribunal_case, step_params: step_params, next_step: next_step) }

  describe '#destination' do
    context 'when `next_step` is present' do
      let(:next_step) { { controller: '/home', action: :index } }

      it { is_expected.to have_destination('/home', :index) }
    end

    # Mutant kill
    context 'when the step_params key is a string' do
      let(:step_params) { { 'in_time' => 'yes' } }

      it { is_expected.to have_destination('/steps/details/user_type', :edit) }
    end

    context 'when the step is `in_time`' do
      context 'and the answer is `yes`' do
        let(:step_params) { { in_time: 'yes' } }

        it { is_expected.to have_destination('/steps/details/user_type', :edit) }
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

      it { is_expected.to have_destination('/steps/details/user_type', :edit) }
    end

    context 'when the step is invalid' do
      let(:step_params) { { ungueltig: { waschmaschine: 'nein' } } }

      it 'raises an error' do
        expect { subject.destination }.to raise_error(
          TaxTribs::DecisionTree::InvalidStep, "Invalid step '{:ungueltig=>{:waschmaschine=>\"nein\"}}'"
        )
      end
    end
  end
end
