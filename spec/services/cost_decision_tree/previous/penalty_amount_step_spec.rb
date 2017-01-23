require 'spec_helper'

RSpec.describe CostDecisionTree, '#previous' do
  let(:tribunal_case) { double('TribunalCase') }
  let(:step_params)   { double('Step') }
  let(:next_step)     { nil }
  subject { described_class.new(tribunal_case: tribunal_case, step_params: step_params, next_step: next_step) }

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
end
