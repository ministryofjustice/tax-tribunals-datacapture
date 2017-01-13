require 'spec_helper'

RSpec.describe CaseDetailsPresenter do
  subject { described_class.new(tribunal_case) }

  let(:tribunal_case) { instance_double(TribunalCase) }

  context '#taxpayer' do
    it 'returns a taxpayer presenter instance' do
      expect(subject.taxpayer).to be_an_instance_of(TaxpayerDetailsPresenter)
    end
  end

  context '#documents' do
    it 'returns a documents presenter instance' do
      expect(subject.documents).to be_an_instance_of(DocumentsSubmittedPresenter)
    end
  end

  context '#fee_answers' do
    it 'returns a fee answers presenter instance' do
      expect(subject.fee_answers).to be_an_instance_of(FeeDetailsAnswersPresenter)
    end
  end

  context '#appeal_lateness_answers' do
    it 'returns a appeal lateness answers presenter instance' do
      expect(subject.appeal_lateness_answers).to be_an_instance_of(AppealLatenessAnswersPresenter)
    end
  end
end
