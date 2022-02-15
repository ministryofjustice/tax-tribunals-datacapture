require 'spec_helper'

RSpec.describe TaxTribs::ClosureDecisionTree do
  let(:tribunal_case) { double('TribunalCase', user_id: user_id) }
  let(:step_params) { double('Step') }
  let(:next_step) { nil }
  let(:user_id) { nil }

  subject { described_class.new(tribunal_case: tribunal_case, step_params: step_params, next_step: next_step) }

  describe '#destination' do
    context 'when `next_step` is present' do
      let(:next_step) { { controller: '/home', action: :index } }

      it { is_expected.to have_destination('/home', :index) }
    end

    context 'case type' do
      context 'user is logged in' do
        let(:user_id)       { '123456' }

        describe 'when the step_params key is a string' do
          let(:step_params) { { 'case_type' => 'anything' } }

          it { is_expected.to have_destination('/steps/details/user_type', :edit) }
        end

        describe 'when the step is `case_type`' do
          let(:step_params) { { case_type: 'anything' } }

          it { is_expected.to have_destination('/steps/details/user_type', :edit) }
        end
      end

      context 'user is not logged in' do
        describe 'when the step_params key is a string' do
          let(:step_params) { { 'case_type' => 'anything' } }

          it { is_expected.to have_destination('/steps/save_and_return', :edit) }

          it 'next_step value is set' do
            subject.destination
            expect(subject.next_step).to eq({ action: :edit, controller: '/steps/select_language' })
          end
        end
      end
    end

    context 'when the step is `enquiry_details`' do
      let(:step_params) { { enquiry_details: 'anything' } }

      it { is_expected.to have_destination(:additional_info, :edit) }
    end

    context 'when the step is `additional_info`' do
      let(:step_params) { { additional_info: 'anything' } }

      it { is_expected.to have_destination(:eu_exit, :edit) }
    end

    context 'when the step is `eu_exit`' do
      let(:step_params) { { eu_exit: 'anything' } }

      it { is_expected.to have_destination(:need_support, :edit) }
    end

    context 'when step is `need_support`' do
      let(:step_params) { { need_support: 'anything' } }

      context 'and the answer is `yes`' do
        let(:tribunal_case) { instance_double(TribunalCase, need_support: NeedSupport::YES.to_s) }

        it { is_expected.to have_destination(:what_support, :edit) }
      end

      context 'and the answer is `no`' do
        let(:tribunal_case) { instance_double(TribunalCase, need_support: NeedSupport::NO.to_s) }

        it { is_expected.to have_destination(:support_documents, :edit) }
      end
    end

    context 'when step is `what_support`' do
      let(:step_params) { { what_support: 'anything' } }

      it { is_expected.to have_destination(:support_documents, :edit) }
    end

    context 'when the step is `support_documents`' do
      let(:step_params) { { support_documents: 'anything' } }

      it { is_expected.to have_destination(:check_answers, :show) }
    end

    context 'when the step is `check_answers`' do
      let(:step_params) { {check_answers: 'anything'} }

      it { is_expected.to have_destination('/home', :index) }
    end

    context 'when the step is invalid' do
      let(:step_params) { {ungueltig: {waschmaschine: 'nein'}} }

      it 'raises an error' do
        expect { subject.destination }.to raise_error(
          TaxTribs::DecisionTree::InvalidStep, "Invalid step '{:ungueltig=>{:waschmaschine=>\"nein\"}}'"
        )
      end
    end
  end
end
