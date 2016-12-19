require 'spec_helper'

RSpec.describe CostDecisionTree do
  let(:tribunal_case) { double('TribunalCase') }
  let(:step_params)   { double('Step') }
  let(:next_step)     { nil }
  subject { described_class.new(tribunal_case: tribunal_case, step_params: step_params, next_step: next_step) }

  describe '#destination' do
    context 'when the step is `challenged_decision`' do
      let(:step_params) { { challenged_decision: 'anything' } }

      it { is_expected.to have_destination(:case_type, :edit) }
    end

    context 'when the step is `case_type`' do
      let(:step_params)         { { case_type: 'anything' } }
      let(:tribunal_case)       { instance_double(TribunalCase, case_type: case_type, challenged_decision: challenged_decision) }
      let(:challenged_decision) { nil }

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

      context 'and the case type is one that should ask neither dispute type nor penalty' do
        let(:case_type) { CaseType.new(:dummy, ask_dispute_type: false, ask_penalty: false) }

        it { is_expected.to have_destination(:determine_cost, :show) }
      end

      context 'and the answer is show more' do
        let(:step_params) { { case_type: '_show_more' } }
        let(:case_type)   { nil }

        it { is_expected.to have_destination(:case_type_show_more, :edit) }
      end
    end

    context 'when the step is `dispute_type`' do
      let(:step_params)   { { dispute_type: 'anything' } }
      let(:tribunal_case) { instance_double(TribunalCase, dispute_type: dispute_type) }

      context 'and the dispute type is PAYE coding notice' do
        let(:dispute_type) { DisputeType::PAYE_CODING_NOTICE }

        it { is_expected.to have_destination(:determine_cost, :show) }
      end

      context 'and the dispute type is penalty or surcharge' do
        let(:dispute_type) { DisputeType::PENALTY }

        it { is_expected.to have_destination(:penalty_amount, :edit) }
      end

      context 'and the dispute type is amount of tax' do
        let(:dispute_type) { DisputeType::AMOUNT_OF_TAX }

        it { is_expected.to have_destination(:determine_cost, :show) }
      end

      context 'and the dispute type is amount of tax and penalty' do
        let(:dispute_type) { DisputeType::AMOUNT_AND_PENALTY }

        it { is_expected.to have_destination(:determine_cost, :show) }
      end

      context 'and the dispute type is ask for a decision on an enquiry' do
        let(:dispute_type) { DisputeType::DECISION_ON_ENQUIRY }

        it { is_expected.to have_destination(:determine_cost, :show) }
      end

      context 'and the dispute type is other' do
        let(:dispute_type) { DisputeType::OTHER }

        it { is_expected.to have_destination(:determine_cost, :show) }
      end
    end

    context 'when the step is `penalty_amount`' do
      let(:step_params) { { penalty_amount: 'anything' } }

      it { is_expected.to have_destination(:determine_cost, :show) }
    end

    context 'when the step is invalid' do
      let(:step_params) { { ungueltig: { waschmaschine: 'nein' } } }

      it 'raises an error' do
        expect { subject.destination }.to raise_error(RuntimeError)
      end
    end
  end

  describe '#previous' do
    context 'when the step is `challenged_decision`' do
      let(:step_params) { { challenged_decision: 'anything' } }

      it { is_expected.to have_previous(:start, :show) }
    end

    context 'when the step is `case_type`' do
      let(:step_params) { { case_type: 'anything' } }

      it { is_expected.to have_previous(:challenged_decision, :edit) }
    end

    context 'when the step is `dispute_type`' do
      let(:step_params) { { dispute_type: 'anything' } }

      it { is_expected.to have_previous(:case_type, :edit) }
    end

    context 'when the step is `penalty_amount`' do
      let(:step_params) { { penalty_amount: 'anything' } }

      it { is_expected.to have_previous(:dispute_type, :edit) }
    end

    context 'when the step is invalid' do
      let(:step_params) { { ungueltig: { waschmaschine: 'nein' } } }

      it 'raises an error' do
        expect { subject.previous }.to raise_error(RuntimeError)
      end
    end
  end
end
