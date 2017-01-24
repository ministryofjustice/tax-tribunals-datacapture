require 'spec_helper'

RSpec.describe DetailsDecisionTree do
  let(:tribunal_case) { double('Object') }
  let(:step_params)   { double('Step') }
  let(:next_step)     { nil }
  subject { described_class.new(tribunal_case: tribunal_case, step_params: step_params, next_step: next_step) }

  describe '#destination' do
    context 'when the step is `taxpayer_type`' do
      context 'and the answer is `individual`' do
        let(:step_params) { { taxpayer_type: 'individual'  } }

        it { is_expected.to have_destination(:individual_details, :edit) }
      end

      context 'and the answer is `company`' do
        let(:step_params) { { taxpayer_type: 'company'  } }

        it { is_expected.to have_destination(:company_details, :edit) }
      end
    end

    context 'when the step is `individual_details`' do
      let(:step_params) { { individual_details: 'anything'  } }

      it { is_expected.to have_destination(:grounds_for_appeal, :edit) }
    end

    context 'when the step is `company_details`' do
      let(:step_params) { { company_details: 'anything'  } }

      it { is_expected.to have_destination(:grounds_for_appeal, :edit) }
    end

    context 'when the step is `grounds_for_appeal`' do
      let(:step_params) { { grounds_for_appeal: 'anything'  } }

      it { is_expected.to have_destination(:outcome, :edit) }
    end

    context 'when the step is `outcome`' do
      let(:step_params) { { outcome: 'anything'  } }

      it { is_expected.to have_destination(:documents_checklist, :edit) }
    end

    context 'when the step is `documents_checklist`' do
      let(:step_params) { { documents_checklist: 'anything'  } }

      it { is_expected.to have_destination(:check_answers, :show) }
    end

    context 'when the step is `check_answers`' do
      let(:step_params) { {check_answers: 'anything'} }

      it { is_expected.to have_destination('/task_list', :index) }
    end

    context 'when the step is invalid' do
      let(:step_params) { { ungueltig: { waschmaschine: 'nein' } } }

      it 'raises an error' do
        expect { subject.destination }.to raise_error(RuntimeError)
      end
    end
  end

  describe '#previous' do
    context 'when the step is `taxpayer_type`' do
      let(:step_params) { { taxpayer_type: 'anything'  } }

      it { is_expected.to have_previous(:start, :show) }
    end

    context 'when the step is `individual_details`' do
      let(:step_params) { { individual_details: 'anything'  } }

      it { is_expected.to have_previous(:taxpayer_type, :edit) }
    end

    context 'when the step is `company_details`' do
      let(:step_params) { { company_details: 'anything'  } }

      it { is_expected.to have_previous(:taxpayer_type, :edit) }
    end

    context 'when the step is `grounds_for_appeal`' do
      let(:step_params) { { grounds_for_appeal: 'anything'  } }

      context 'when the tax payer type is individual' do
        let(:tribunal_case) { instance_double(TribunalCase, taxpayer_type: TaxpayerType::INDIVIDUAL) }

        it { is_expected.to have_previous(:individual_details, :edit) }
      end

      context 'when the tax payer type is company' do
        let(:tribunal_case) { instance_double(TribunalCase, taxpayer_type: TaxpayerType::COMPANY) }

        it { is_expected.to have_previous(:company_details, :edit) }
      end
    end

    context 'when the step is `outcome`' do
      let(:step_params) { { outcome: 'anything'  } }

      it { is_expected.to have_previous(:grounds_for_appeal, :edit) }
    end

    context 'when the step is `documents_checklist`' do
      let(:step_params) { { documents_checklist: 'anything'  } }

      it { is_expected.to have_previous(:outcome, :edit) }
    end

    context 'when the step is `check_answers`' do
      let(:step_params) { { check_answers: 'anything'  } }

      it { is_expected.to have_previous(:documents_checklist, :edit) }
    end

    context 'when the step is invalid' do
      let(:step_params) { { ungueltig: { waschmaschine: 'nein' } } }

      it 'raises an error' do
        expect { subject.previous }.to raise_error(RuntimeError)
      end
    end
  end
end
