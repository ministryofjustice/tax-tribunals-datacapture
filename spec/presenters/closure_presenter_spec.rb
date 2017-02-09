require 'spec_helper'

RSpec.describe ClosurePresenter do
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

  context '#enquiry' do
    it 'returns a closure enquiry answers presenter instance' do
      expect(subject.enquiry_answers).to be_an_instance_of(ClosureEnquiryAnswersPresenter)
    end
  end
end
