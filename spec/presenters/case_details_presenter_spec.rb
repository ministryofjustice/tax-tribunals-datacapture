require 'spec_helper'

RSpec.describe CaseDetailsPresenter do
  subject { described_class.new(tribunal_case) }

  let(:tribunal_case) { instance_double(TribunalCase) }

  context '#taxpayer' do
    it 'returns a taxpayer presenter instance' do
      expect(subject.taxpayer).to be_an_instance_of(TaxpayerDetailsPresenter)
    end
  end

  context '#representative' do
    it 'returns a representative presenter instance' do
      expect(subject.representative).to be_an_instance_of(RepresentativeDetailsPresenter)
    end
  end

  context '#documents' do
    it 'returns a documents presenter instance' do
      expect(subject.documents).to be_an_instance_of(DocumentsSubmittedPresenter)
    end
  end

  context '#appeal_type_answers' do
    it 'returns an appeal type answers presenter instance' do
      expect(subject.appeal_type_answers).to be_an_instance_of(AppealTypeAnswersPresenter)
    end
  end

  context '#appeal_lateness_answers' do
    it 'returns a appeal lateness answers presenter instance' do
      expect(subject.appeal_lateness_answers).to be_an_instance_of(AppealLatenessAnswersPresenter)
    end
  end
end
