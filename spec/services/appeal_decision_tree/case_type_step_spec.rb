require 'spec_helper'

RSpec.describe AppealDecisionTree, '#destination' do
  let(:tribunal_case) { instance_double(TribunalCase, case_type: case_type, user_id: user_id) }
  let(:step_params)   { {case_type: 'anything'} }
  let(:next_step)     { nil }
  let(:case_type)     { nil }
  let(:user_id)       { nil }
  let(:as)            { :save_and_return }


  subject { described_class.new(tribunal_case: tribunal_case, step_params: step_params, next_step: next_step, as: as) }

  context 'for a `show more` option' do
    let(:step_params) { {case_type: '_show_more'} }
    it { is_expected.to have_destination(:case_type_show_more, :edit) }
  end

  context 'for a case asking asking `challenged question`' do
    let(:case_type) { CaseType.new(:dummy, ask_challenged: true) }

    it { is_expected.to have_destination('/steps/challenge/decision', :edit) }
  end

  context 'for a case not asking `challenged question`' do
    context 'when the case type is one that should ask dispute type' do
      let(:case_type) { CaseType.new(:dummy, ask_challenged: false, ask_dispute_type: true) }

      it { is_expected.to have_destination('/steps/appeal/dispute_type', :edit) }
    end

    context 'when the case type is one that should only ask penalty' do
      let(:case_type) { CaseType.new(:dummy, ask_challenged: false, ask_dispute_type: false, ask_penalty: true) }

      it { is_expected.to have_destination('/steps/appeal/penalty_amount', :edit) }
    end
  end

  context 'when the case type is TAX_CREDITS' do
    let(:case_type) { CaseType::TAX_CREDITS }
    it { is_expected.to have_destination(:tax_credits_kickout, :show) }
  end

  context 'when the case type is OTHER' do
    let(:case_type) { CaseType::OTHER }
    it { is_expected.to have_destination('/steps/lateness/in_time', :edit) }
  end

  context 'sign in user' do
    let(:user_id)       { '123456' }
    let(:as)            { nil }

    context 'for a `show more` option' do
      let(:step_params) { {case_type: '_show_more'} }
      it { is_expected.to have_destination(:case_type_show_more, :edit) }
    end
  end

end
