require 'spec_helper'

RSpec.describe ClosureDecisionTree do
  let(:tribunal_case) { double('TribunalCase') }
  let(:step_params) { double('Step') }
  let(:next_step) { nil }

  subject { described_class.new(tribunal_case: tribunal_case, step_params: step_params, next_step: next_step) }

  describe '#destination' do
    context 'when the step is `case_type`' do
      let(:step_params) { { case_type: 'anything' } }

      it { is_expected.to have_destination('/steps/details/user_type', :edit) }
    end

    context 'when the step is `enquiry_details`' do
      let(:step_params) { { enquiry_details: 'anything' } }

      it { is_expected.to have_destination(:additional_info, :edit) }
    end

    context 'when the step is `additional_info`' do
      let(:step_params) { { additional_info: 'anything' } }

      it { is_expected.to have_destination(:support_documents, :edit) }
    end

    context 'when the step is `support_documents`' do
      let(:step_params) { { support_documents: 'anything' } }

      it { is_expected.to have_destination(:check_answers, :show) }
    end

    context 'when the step is `check_answers`' do
      let(:step_params) { {check_answers: 'anything'} }

      it { is_expected.to have_destination('/task_list', :index) }
    end

    context 'when the step is invalid' do
      let(:step_params) { {ungueltig: {waschmaschine: 'nein'}} }

      it 'raises an error' do
        expect { subject.destination }.to raise_error(RuntimeError)
      end
    end
  end

  describe '#previous' do
    context 'when the step is `case_type`' do
      let(:step_params) { { case_type: 'anything' } }

      it { is_expected.to have_previous(:start, :show) }
    end

    context 'when the step is `enquiry_details`' do
      let(:step_params) { { enquiry_details: 'anything' } }

      context 'and there is a representative' do
        context 'and the user is the taxpayer' do
          let(:tribunal_case) { instance_double(TribunalCase, has_representative: HasRepresentative::YES, user_type: UserType::TAXPAYER) }

          it { is_expected.to have_previous('/steps/details/representative_details', :edit) }
        end

        context 'and the user is the representative' do
          let(:tribunal_case) { instance_double(TribunalCase, has_representative: HasRepresentative::YES, user_type: UserType::REPRESENTATIVE) }

          it { is_expected.to have_previous('/steps/details/taxpayer_details', :edit) }
        end
      end

      context 'and there is no representative' do
        let(:tribunal_case) { instance_double(TribunalCase, has_representative: HasRepresentative::NO, user_type: UserType::TAXPAYER) }

        it { is_expected.to have_previous('/steps/details/has_representative', :edit) }
      end
    end

    context 'when the step is `additional_info`' do
      let(:step_params) { { additional_info: 'anything' } }

      it { is_expected.to have_previous(:enquiry_details, :edit) }
    end

    context 'when the step is `support_documents`' do
      let(:step_params) { { support_documents: 'anything' } }

      it { is_expected.to have_previous(:additional_info, :edit) }
    end

    context 'when the step is `check_answers`' do
      let(:step_params) { { check_answers: 'anything' } }

      it { is_expected.to have_previous(:support_documents, :edit) }
    end

    context 'when the step is invalid' do
      let(:step_params) { {ungueltig: {waschmaschine: 'nein'}} }

      it 'raises an error' do
        expect { subject.previous }.to raise_error(RuntimeError)
      end
    end
  end
end
