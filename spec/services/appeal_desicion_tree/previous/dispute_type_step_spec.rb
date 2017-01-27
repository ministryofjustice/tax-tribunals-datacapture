require 'spec_helper'

RSpec.describe AppealDecisionTree, '#previous' do
  let(:tribunal_case) { double('TribunalCase') }
  let(:step_params)   { double('Step') }
  let(:next_step)     { nil }
  subject { described_class.new(tribunal_case: tribunal_case, step_params: step_params, next_step: next_step) }

  context 'when the step is `dispute_type`' do
    let(:step_params)   { { dispute_type: 'anything' } }
    let(:tribunal_case) { instance_double(TribunalCase, case_type: CaseType.new(:foo)) }

    context 'when the case type was listed on the `case_type` step' do
      before do
        expect(Steps::Appeal::CaseTypeForm).to receive(:choices).and_return(['foo'])
      end

      it { is_expected.to have_previous(:case_type, :edit) }
    end

    context 'when the case type was listed on the `case_type_show_more` step' do
      before do
        expect(Steps::Appeal::CaseTypeForm).to receive(:choices).and_return(['not_foo'])
      end

      it { is_expected.to have_previous(:case_type_show_more, :edit) }
    end
  end
end
