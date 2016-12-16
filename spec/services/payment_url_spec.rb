require 'spec_helper'

RSpec.describe PaymentUrl do
  let(:attributes) { {case_reference: 'TC/12345', confirmation_code: 'ABCDEF'} }

  subject { described_class.new(attributes) }

  before do
    allow(ENV).to receive(:fetch).with('PAYMENT_ENDPOINT').and_return('http://payments.com')
  end

  describe '.new' do
    it 'accepts a case_reference and a confirmation_code' do
      expect(subject.case_reference).to eq('TC/12345')
      expect(subject.confirmation_code).to eq('ABCDEF')
    end
  end

  describe '#call!' do
    let(:endpoint) { 'http://payments.com/case_requests' }
    let(:headers) { {content_type: :json} }
    let(:payload) {
      {case_request: {case_reference: 'TC/12345', confirmation_code: 'ABCDEF'}}.to_json
    }

    before do
      allow(RestClient).to receive(:post).with(endpoint, payload, headers).and_return(response)
    end

    context 'for a successful request' do
      let(:response) { double('Response', body: {return_url: 'http://www.example.com/payment'}.to_json) }

      it 'retrieves the payment URL' do
        subject.call!
        expect(subject.payment_url).to eq('http://www.example.com/payment')
      end
    end

    context 'for an unsuccessful request' do
      let(:response) { double('Response', body: {error: 'case not found'}.to_json) }

      it 'raises an exception with the error' do
        expect { subject.call! }.to raise_exception('case not found')
      end
    end
  end
end
