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
      let(:case_type)     { CaseType.new(:anything) }
      let(:tribunal_case) { instance_double(TribunalCase, case_type: case_type, dispute_type: dispute_type) }

      context 'and the dispute type should ask for a penalty amount' do
        let(:dispute_type) { instance_double(DisputeType, ask_penalty?: true, ask_tax?: false) }

        it { is_expected.to have_destination(:penalty_amount, :edit) }
      end

      context 'and the dispute type should ask for a tax amount' do
        let(:dispute_type) { instance_double(DisputeType, ask_penalty?: false, ask_tax?: true) }

        it { is_expected.to have_destination(:tax_amount, :edit) }
      end

      context 'and the dispute type should not ask for a penalty or tax amount but the dispute_type asks hardship and the case_type asks hardship' do
        let(:dispute_type) { instance_double(DisputeType, ask_penalty?: false, ask_tax?: false, ask_hardship?: true) }
        let(:case_type)     { CaseType.new(:anything, ask_hardship: true) }

        it { is_expected.to have_destination('/steps/hardship/disputed_tax_paid', :edit) }
      end

      context 'and the dispute type should not ask for a penalty or tax amount but the dispute_type asks hardship but the case_type does not ask hardship' do
        let(:dispute_type) { instance_double(DisputeType, ask_penalty?: false, ask_tax?: false, ask_hardship?: true) }
        let(:case_type)     { CaseType.new(:anything, ask_hardship: false) }

        it { is_expected.to have_destination(:determine_cost, :show) }
      end

      context 'and the dispute type should not ask for a penalty amount, tax amount or hardship' do
        let(:dispute_type) { instance_double(DisputeType, ask_penalty?: false, ask_tax?: false, ask_hardship?: false) }

        it { is_expected.to have_destination(:determine_cost, :show) }
      end
    end

    context 'when the step is `penalty_amount`' do
      let(:step_params) { { penalty_amount: 'anything' } }
      let(:tribunal_case) { instance_double(TribunalCase, case_type: case_type, dispute_type: dispute_type) }

      context 'and the case type should ask hardship and the dispute_type should ask hardship' do
        let(:case_type)    { CaseType.new(:anything, ask_hardship: true) }
        let(:dispute_type) { instance_double(DisputeType, ask_hardship?: true) }

        it { is_expected.to have_destination('/steps/hardship/disputed_tax_paid', :edit) }
      end

      context 'and the case type should ask the hardship questions but the dispute_type should not' do
        let(:case_type) { CaseType.new(:anything, ask_hardship: true) }
        let(:dispute_type) { instance_double(DisputeType, ask_hardship?: false) }

        it { is_expected.to have_destination(:determine_cost, :show) }
      end

      context 'and the case type should not ask the hardship questions but the dispute_type is one that otherwise should' do
        let(:case_type) { CaseType.new(:anything, ask_hardship: false) }
        let(:dispute_type) { instance_double(DisputeType, ask_hardship?: true) }

        it { is_expected.to have_destination(:determine_cost, :show) }
      end

      context 'and the case type should not ask the hardship questions and the dispute_type should not either' do
        let(:case_type) { CaseType.new(:anything, ask_hardship: false) }
        let(:dispute_type) { instance_double(DisputeType, ask_hardship?: false) }

        it { is_expected.to have_destination(:determine_cost, :show) }
      end
    end

    context 'when the step is `tax_amount`' do
      let(:step_params) { { tax_amount: 'anything' } }
      let(:tribunal_case) { instance_double(TribunalCase, case_type: case_type, dispute_type: dispute_type) }

      context 'and the case type should ask hardship and the dispute_type should ask hardship' do
        let(:case_type)    { CaseType.new(:anything, ask_hardship: true) }
        let(:dispute_type) { instance_double(DisputeType, ask_hardship?: true) }

        it { is_expected.to have_destination('/steps/hardship/disputed_tax_paid', :edit) }
      end

      context 'and the case type should ask the hardship questions but the dispute_type should not' do
        let(:case_type) { CaseType.new(:anything, ask_hardship: true) }
        let(:dispute_type) { instance_double(DisputeType, ask_hardship?: false) }

        it { is_expected.to have_destination(:determine_cost, :show) }
      end

      context 'and the case type should not ask the hardship questions but the dispute_type is one that otherwise should' do
        let(:case_type) { CaseType.new(:anything, ask_hardship: false) }
        let(:dispute_type) { instance_double(DisputeType, ask_hardship?: true) }

        it { is_expected.to have_destination(:determine_cost, :show) }
      end

      context 'and the case type should not ask the hardship questions and the dispute_type should not either' do
        let(:case_type) { CaseType.new(:anything, ask_hardship: false) }
        let(:dispute_type) { instance_double(DisputeType, ask_hardship?: false) }

        it { is_expected.to have_destination(:determine_cost, :show) }
      end
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

    context 'when the step is `case_type_show_more`' do
      let(:step_params) { { case_type_show_more: 'anything' } }

      it { is_expected.to have_previous(:case_type, :edit) }
    end

    context 'when the step is `dispute_type`' do
      let(:step_params)   { { dispute_type: 'anything' } }
      let(:tribunal_case) { instance_double(TribunalCase, case_type: CaseType.new(:foo)) }

      context 'when the case type was listed on the `case_type` step' do
        before do
          expect(Steps::Cost::CaseTypeForm).to receive(:choices).and_return(['foo'])
        end

        it { is_expected.to have_previous(:case_type, :edit) }
      end

      context 'when the case type was listed on the `case_type_show_more` step' do
        before do
          expect(Steps::Cost::CaseTypeForm).to receive(:choices).and_return(['not_foo'])
        end

        it { is_expected.to have_previous(:case_type_show_more, :edit) }
      end
    end

    context 'when the step is `penalty_amount`' do
      let(:step_params) { { penalty_amount: 'anything' } }
      let(:tribunal_case) { instance_double(TribunalCase, case_type: CaseType.new(:foo), dispute_type?: has_dispute_type) }

      context 'when the case does not have a dispute_type' do
        let(:has_dispute_type) { false }

        context 'when the case type was listed on the `case_type` step' do
          before do
            expect(Steps::Cost::CaseTypeForm).to receive(:choices).and_return(['foo'])
          end

          it { is_expected.to have_previous(:case_type, :edit) }
        end

        context 'when the case type was listed on the `case_type_show_more` step' do
          before do
            expect(Steps::Cost::CaseTypeForm).to receive(:choices).and_return(['not_foo'])
          end

          it { is_expected.to have_previous(:case_type_show_more, :edit) }
        end
      end

      context 'when the case has a dispute type' do
        let(:has_dispute_type) { true }

        it { is_expected.to have_previous(:dispute_type, :edit) }
      end
    end

    context 'when the step is `tax_amount`' do
      let(:step_params) { { tax_amount: 'anything' } }
      let(:tribunal_case) { instance_double(TribunalCase, case_type: CaseType.new(:foo), dispute_type?: has_dispute_type) }

      context 'when the case does not have a dispute_type' do
        let(:has_dispute_type) { false }

        context 'when the case type was listed on the `case_type` step' do
          before do
            expect(Steps::Cost::CaseTypeForm).to receive(:choices).and_return(['foo'])
          end

          it { is_expected.to have_previous(:case_type, :edit) }
        end

        context 'when the case type was listed on the `case_type_show_more` step' do
          before do
            expect(Steps::Cost::CaseTypeForm).to receive(:choices).and_return(['not_foo'])
          end

          it { is_expected.to have_previous(:case_type_show_more, :edit) }
        end
      end

      context 'when the case has a dispute type' do
        let(:has_dispute_type) { true }

        it { is_expected.to have_previous(:dispute_type, :edit) }
      end
    end

    context 'when the step is invalid' do
      let(:step_params) { { ungueltig: { waschmaschine: 'nein' } } }

      it 'raises an error' do
        expect { subject.previous }.to raise_error(RuntimeError)
      end
    end
  end
end
