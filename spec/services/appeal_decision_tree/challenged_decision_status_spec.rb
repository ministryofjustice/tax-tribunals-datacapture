require 'spec_helper'

RSpec.describe AppealDecisionTree, '#destination' do
  let(:next_step)     { nil }
  let(:step_params)   { {challenged_decision_status: 'anything'} }
  let(:case_type)     { nil }
  let(:tribunal_case) {
    instance_double(
      TribunalCase,
      challenged_decision_status: challenged_decision_status,
      case_type: case_type
    )
  }

  subject { described_class.new(tribunal_case: tribunal_case, step_params: step_params, next_step: next_step) }

  context 'when the step is `challenged_decision_status`' do
    context 'and the status is `pending`' do
      let(:challenged_decision_status) { ChallengedDecisionStatus::PENDING }

      it { is_expected.to have_destination(:must_wait_for_challenge_decision, :show) }
    end

    context 'and the status is other than `pending`' do
      let(:challenged_decision_status) { ChallengedDecisionStatus::RECEIVED }

      context 'for a case with disputes' do
        let(:case_type) { CaseType::BINGO_DUTY }

        it { is_expected.to have_destination(:dispute_type, :edit) }
      end

      context 'for a case with penalties' do
        let(:case_type) { CaseType::APN_PENALTY }

        it { is_expected.to have_destination(:penalty_amount, :edit) }
      end

      context 'for a case that has neither penalties or disputes' do
        let(:case_type) { CaseType::COUNTER_TERRORISM }

        it { is_expected.to have_destination('/steps/lateness/in_time', :edit) }
      end
    end
  end
end
