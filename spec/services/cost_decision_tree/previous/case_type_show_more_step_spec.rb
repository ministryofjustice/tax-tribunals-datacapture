require 'spec_helper'

RSpec.describe CostDecisionTree, '#previous' do
  let(:tribunal_case) { double('TribunalCase') }
  let(:step_params)   { double('Step') }
  let(:next_step)     { nil }
  subject { described_class.new(tribunal_case: tribunal_case, step_params: step_params, next_step: next_step) }

  context 'when the step is `case_type_show_more`' do
    let(:step_params) { { case_type_show_more: 'anything' } }

    it { is_expected.to have_previous(:case_type, :edit) }
  end
end
