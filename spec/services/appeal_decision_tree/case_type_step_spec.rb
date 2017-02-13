require 'spec_helper'

RSpec.describe AppealDecisionTree, '#destination' do
  let(:tribunal_case) { double('TribunalCase') }
  let(:step_params)   { double('Step') }
  let(:next_step)     { nil }
  subject { described_class.new(tribunal_case: tribunal_case, step_params: step_params, next_step: next_step) }

  context 'when the step is `case_type`' do
    let(:step_params)         { { case_type: 'anything' } }
    let(:tribunal_case)       { instance_double(TribunalCase, case_type: case_type, challenged_decision: challenged_decision) }
    let(:challenged_decision) { nil }

    context 'and the case type is a challenged indirect tax' do
      let(:case_type) { CaseType.new(:dummy, direct_tax: false) }
      let(:challenged_decision) { ChallengedDecision::YES }

      it { is_expected.to have_destination(:challenged_decision_status, :edit) }
    end

    context 'and the case type is a direct tax' do
      let(:case_type) { CaseType.new(:dummy, direct_tax: true, ask_dispute_type: true) }

      context 'and the case has been challenged' do
        let(:challenged_decision) { ChallengedDecision::YES }

        it { is_expected.to have_destination(:dispute_type, :edit) }
      end

      context 'and the case has not been challenged' do
        let(:challenged_decision) { ChallengedDecision::NO }

        it { is_expected.to have_destination(:must_challenge_hmrc, :show) }
      end
    end

    context 'and the case type is one that should ask dispute type' do
      let(:case_type) { CaseType.new(:dummy, ask_dispute_type: true) }

      it { is_expected.to have_destination(:dispute_type, :edit) }
    end

    context 'and the case type is one that should only ask penalty' do
      let(:case_type) { CaseType.new(:dummy, ask_dispute_type: false, ask_penalty: true) }

      it { is_expected.to have_destination(:penalty_amount, :edit) }
    end

    context 'and the case type is one that should only ask hardship' do
      let(:case_type) { CaseType.new(:dummy, ask_dispute_type: false, ask_penalty: false, ask_hardship: true) }

      it { is_expected.to have_destination('/steps/hardship/disputed_tax_paid', :edit) }
    end

    context 'and the case type is one that should ask neither dispute type nor penalty' do
      let(:case_type) { CaseType.new(:dummy, ask_dispute_type: false, ask_penalty: false) }

      it { is_expected.to have_destination('/steps/lateness/in_time', :edit) }
    end

    context 'and the answer is show more' do
      let(:step_params) { { case_type: '_show_more' } }
      let(:case_type)   { nil }

      it { is_expected.to have_destination(:case_type_show_more, :edit) }
    end
  end
end
