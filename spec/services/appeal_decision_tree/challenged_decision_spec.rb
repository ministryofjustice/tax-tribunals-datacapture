require 'spec_helper'

RSpec.describe AppealDecisionTree, '#destination' do
  let(:step_params)   { double('Step') }
  let(:next_step)     { nil }
  let(:step_params)   { {challenged_decision: 'anything'} }
  let(:tribunal_case) { instance_double(TribunalCase, case_type: case_type, challenged_decision: challenged_decision) }

  let(:challenged_decision) { nil }

  subject { described_class.new(tribunal_case: tribunal_case, step_params: step_params, next_step: next_step) }

  context 'for a direct tax' do
    let(:case_type) { CaseType.new(:dummy, direct_tax: true) }

    context 'and the case has not been challenged' do
      let(:challenged_decision) { ChallengedDecision::NO }

      it { is_expected.to have_destination(:must_challenge_hmrc, :show) }
    end

    context 'and the case has been challenged' do
      let(:challenged_decision) { ChallengedDecision::YES }

      it { is_expected.to have_destination(:challenged_decision_status, :edit) }
    end
  end

  context 'for an indirect tax' do
    let(:case_type) { CaseType.new(:dummy, direct_tax: false) }

    context 'and the case has not been challenged' do
      let(:challenged_decision) { ChallengedDecision::NO }

      it { is_expected.to have_destination(:dispute_type, :edit) }
    end

    context 'and the case has been challenged' do
      let(:challenged_decision) { ChallengedDecision::YES }

      it { is_expected.to have_destination(:challenged_decision_status, :edit) }
    end
  end
end
