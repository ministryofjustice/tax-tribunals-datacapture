require 'spec_helper'

RSpec.describe ClosureDecisionTree do
  let(:tribunal_case) { double('TribunalCase') }
  let(:step_params) { double('Step') }
  let(:next_step) { nil }

  subject { described_class.new(tribunal_case: tribunal_case, step_params: step_params, next_step: next_step) }

  describe '#destination' do
    context 'when the step is `case_type`' do
      let(:step_params) { { case_type: 'anything' } }

      it { is_expected.to have_destination('/steps/details/taxpayer_type', :edit) }
    end

    context 'when the step is `enquiry_details`' do
      let(:step_params) { { enquiry_details: 'anything' } }

      it { is_expected.to have_destination(:additional_info, :edit) }
    end

    context 'when the step is `additional_info`' do
      let(:step_params) { { additional_info: 'anything' } }

      it { is_expected.to have_destination(:support_documents, :edit) }
    end

    # TODO: change once we have the `check your answers` step
    context 'when the step is `support_documents`' do
      let(:step_params) { { support_documents: 'anything' } }

      it { is_expected.to have_destination(:start, :show) }
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

      it { is_expected.to have_previous('/steps/details/taxpayer_type', :edit) }
    end

    context 'when the step is `additional_info`' do
      let(:step_params) { { additional_info: 'anything' } }

      it { is_expected.to have_previous(:enquiry_details, :edit) }
    end

    context 'when the step is `support_documents`' do
      let(:step_params) { { support_documents: 'anything' } }

      it { is_expected.to have_previous(:additional_info, :edit) }
    end

    context 'when the step is invalid' do
      let(:step_params) { {ungueltig: {waschmaschine: 'nein'}} }

      it 'raises an error' do
        expect { subject.previous }.to raise_error(RuntimeError)
      end
    end
  end
end
