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
      context 'and the answer is `vat`' do
        let(:step_params) { { case_type: 'vat' } }

        it { is_expected.to have_destination(:dispute_type, :edit) }
      end

      context 'and the answer is `income_tax`' do
        let(:step_params) { { case_type: 'income_tax' } }

        context 'and the case is challenged' do
          let(:tribunal_case) { instance_double(TribunalCase, challenged_decision: ChallengedDecision::YES) }

          it { is_expected.to have_destination(:dispute_type, :edit) }
        end

        context 'and the case is unchallenged' do
          let(:tribunal_case) { instance_double(TribunalCase, challenged_decision: ChallengedDecision::NO) }

          it { is_expected.to have_destination(:must_challenge_hmrc, :show) }
        end
      end

      %w(
        apn_penalty
        inaccurate_return
        closure_notice
        information_notice
        request_permission_for_review
        other
      ).each do |tax_type|
        context "and the answer is `#{tax_type}`" do
          let(:step_params) { { case_type: tax_type } }

          it { is_expected.to have_destination(:determine_cost, :show) }
        end
      end
    end

    context 'when the step is `dispute_type`' do
      context 'and the answer is `paye_coding_notice`' do
        let(:step_params) { { dispute_type: 'paye_coding_notice' } }

        it { is_expected.to have_destination(:determine_cost, :show) }
      end

      context 'and the answer is `penalty`' do
        let(:step_params) { { dispute_type: 'penalty' } }

        it { is_expected.to have_destination(:penalty_amount, :edit) }
      end

      context 'and the answer is `amount_of_tax`' do
        let(:step_params) { { dispute_type: 'amount_of_tax' } }

        it { is_expected.to have_destination(:determine_cost, :show) }
      end

      context 'and the answer is `amount_and_penalty`' do
        let(:step_params) { { dispute_type: 'amount_and_penalty' } }

        it { is_expected.to have_destination(:determine_cost, :show) }
      end

      context 'and the answer is `decision_on_enquiry`' do
        let(:step_params) { { dispute_type: 'decision_on_enquiry' } }

        it { is_expected.to have_destination(:determine_cost, :show) }
      end

      context 'and the answer is `other`' do
        let(:step_params) { { dispute_type: 'other' } }

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
