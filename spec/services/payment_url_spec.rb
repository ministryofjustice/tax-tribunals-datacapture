require 'spec_helper'

RSpec.describe PaymentUrl do
  let(:attributes) { {case_reference: 'TC/12345', confirmation_code: 'ABCDEF'} }

  subject { described_class.new(attributes) }

  describe '.new' do
    it 'accepts a case_reference and a confirmation_code' do
      expect(subject.case_reference).to eq('TC/12345')
      expect(subject.confirmation_code).to eq('ABCDEF')
    end
  end

  # TODO: API call not yet implemented
  describe '#call!' do
    it 'retrieves the payment URL' do
      subject.call!
      expect(subject.payment_url).to eq('http://www.example.com')
    end
  end
end
