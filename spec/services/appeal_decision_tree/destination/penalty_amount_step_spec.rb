require 'spec_helper'

RSpec.describe AppealDecisionTree, '#destination' do
  let(:next_step)     { nil }
  subject { described_class.new(tribunal_case: tribunal_case, step_params: step_params, next_step: next_step) }

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
end
