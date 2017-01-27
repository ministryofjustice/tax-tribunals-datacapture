require 'spec_helper'

RSpec.describe AppealDecisionTree, '#destination' do
  let(:next_step)     { nil }
  subject { described_class.new(tribunal_case: tribunal_case, step_params: step_params, next_step: next_step) }

	context 'when the step is `dispute_type`' do
		let(:step_params)   { { dispute_type: 'anything' } }
		let(:case_type)     { CaseType.new(:anything) }
		let(:tribunal_case) { instance_double(TribunalCase, case_type: case_type, dispute_type: dispute_type) }

		context 'and the dispute type should ask for a penalty amount' do
			let(:dispute_type) { instance_double(DisputeType, ask_penalty?: true, ask_tax?: false, ask_penalty_and_tax?: false) }

			it { is_expected.to have_destination(:penalty_amount, :edit) }
		end

		context 'and the dispute type should ask for a tax amount' do
			let(:dispute_type) { instance_double(DisputeType, ask_penalty?: false, ask_tax?: true, ask_penalty_and_tax?: false) }

			it { is_expected.to have_destination(:tax_amount, :edit) }
		end

		context 'and the dispute type should ask for the penalty and tax amounts' do
			let(:dispute_type) { instance_double(DisputeType, ask_penalty?: false, ask_tax?: false, ask_penalty_and_tax?: true) }

			it { is_expected.to have_destination(:penalty_and_tax_amounts, :edit) }
		end

		context 'and the dispute type should not ask for a penalty or tax amount but the dispute_type asks hardship and the case_type asks hardship' do
			let(:dispute_type) { instance_double(DisputeType, ask_penalty?: false, ask_tax?: false, ask_penalty_and_tax?: false, ask_hardship?: true) }
			let(:case_type)     { CaseType.new(:anything, ask_hardship: true) }

			it { is_expected.to have_destination('/steps/hardship/disputed_tax_paid', :edit) }
		end

		context 'and the dispute type should not ask for a penalty or tax amount but the dispute_type asks hardship but the case_type does not ask hardship' do
			let(:dispute_type) { instance_double(DisputeType, ask_penalty?: false, ask_tax?: false, ask_penalty_and_tax?: false, ask_hardship?: true) }
			let(:case_type)     { CaseType.new(:anything, ask_hardship: false) }

			it { is_expected.to have_destination(:determine_cost, :show) }
		end

		context 'and the dispute type should not ask for a penalty amount, tax amount or hardship' do
			let(:dispute_type) { instance_double(DisputeType, ask_penalty?: false, ask_tax?: false, ask_penalty_and_tax?: false, ask_hardship?: false) }

			it { is_expected.to have_destination(:determine_cost, :show) }
		end
	end
end
