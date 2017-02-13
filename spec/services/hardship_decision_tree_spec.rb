require 'spec_helper'

RSpec.describe HardshipDecisionTree do
  let(:tribunal_case) { double('TribunalCase') }
  let(:step_params)   { double('Step') }
  let(:next_step)     { nil }
  subject { described_class.new(tribunal_case: tribunal_case, step_params: step_params, next_step: next_step) }

  describe '#destination' do
    context 'when the step is `disputed_tax_paid`' do
      let(:step_params)   { { disputed_tax_paid: 'anything' } }
      let(:tribunal_case) { instance_double(TribunalCase, disputed_tax_paid: disputed_tax_paid) }

      context 'and the disputed tax has been paid' do
        let(:disputed_tax_paid) { DisputedTaxPaid::YES }

        it { is_expected.to have_destination('/steps/lateness/in_time', :edit) }
      end

      context 'and the disputed tax has not been paid' do
        let(:disputed_tax_paid) { DisputedTaxPaid::NO }

        it { is_expected.to have_destination(:hardship_review_requested, :edit) }
      end
    end

    context 'when the step is `hardship_review_requested`' do
      let(:step_params) { { hardship_review_requested: 'anything' } }
      let(:tribunal_case) { instance_double(TribunalCase, hardship_review_requested: hardship_review_requested) }

      context 'and a hardship review has been requested' do
        let(:hardship_review_requested) { HardshipReviewRequested::YES }

        it { is_expected.to have_destination(:hardship_review_status, :edit) }
      end

      context 'and a hardship review has not been requested' do
        let(:hardship_review_requested) { HardshipReviewRequested::NO }

        it { is_expected.to have_destination('/steps/lateness/in_time', :edit) }
      end
    end

    context 'when the step is `hardship_review_status`' do
      let(:step_params) { { hardship_review_status: 'anything' } }

      it { is_expected.to have_destination('/steps/lateness/in_time', :edit) }
    end

    context 'when the step is invalid' do
      let(:step_params) { { ungueltig: { waschmaschine: 'nein' } } }

      it 'raises an error' do
        expect { subject.destination }.to raise_error(RuntimeError)
      end
    end
  end
end
