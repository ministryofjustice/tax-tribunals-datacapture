require 'spec_helper'

RSpec.describe AppealDecisionTree, '#destination' do
  let(:next_step)     { nil }
  let(:step_params)   { {challenged_decision_status: 'anything'} }
  let(:tribunal_case) { instance_double(TribunalCase, challenged_decision_status: challenged_decision_status) }

  subject { described_class.new(tribunal_case: tribunal_case, step_params: step_params, next_step: next_step) }

  context 'when the step is `challenged_decision_status`' do
    context 'and the status is `pending`' do
      let(:challenged_decision_status) { ChallengedDecisionStatus::PENDING }

      it { is_expected.to have_destination(:must_wait_for_challenge_decision, :show) }
    end

    context 'and the status is other than `pending`' do
      let(:challenged_decision_status) { ChallengedDecisionStatus::RECEIVED }

      it { is_expected.to have_destination(:dispute_type, :edit) }
    end
  end
end
