require 'spec_helper'

RSpec.describe CaseCreator do

  let!(:tribunal_case) { TribunalCase.create }

  subject { described_class.new(tribunal_case) }

  describe '.new' do
    it 'accepts a tribunal case' do
      expect(subject.tribunal_case).to eq(tribunal_case)
    end

    it 'defaults to no errors' do
      expect(subject.errors).to eq([])
    end
  end

  describe '#call' do
    let(:glimr_response_double) {
      double('Response', response_body: {tribunalCaseNumber: 'TC/12345', confirmationCode: 'ABCDEF'})
    }

    # TODO: add all the params once we know what to send
    let(:glimr_params) {
      {jurisdictionId: 8}
    }

    before do
      allow(GlimrApiClient::RegisterNewCase).to receive(:call).
          with(hash_including(glimr_params)).and_return(glimr_response_double)
    end

    context 'registering the case into glimr' do
      before do
        expect(subject).to receive(:create_glimr_case!).and_call_original
      end

      it 'retrieves the tc_number and conf_code' do
        subject.call
        expect(subject.tc_number).to eq('TC/12345')
        expect(subject.conf_code).to eq('ABCDEF')
      end

      context 'when there are errors' do
        let(:glimr_response_double) { double('Response', response_body: nil) }

        it 'should return false' do
          expect(subject.call).to eq(false)
        end

        # TODO: change once the retrieve_payment_url! method is implemented
        it 'should not call the API to retrieve the payment url' do
          expect(subject.call).to eq(false)
          expect(subject.payment_url).to be_nil
        end
      end
    end

    context 'retrieving the payment url' do
      before do
        expect(subject).to receive(:create_glimr_case!).and_call_original
        expect(subject).to receive(:retrieve_payment_url!).and_call_original
      end

      # TODO: change once the retrieve_payment_url! method is implemented
      it 'retrieves the tc_number and conf_code' do
        subject.call
        expect(subject.payment_url).to eq('http://www.example.com')
      end

      context 'when there are errors' do
        pending 'TBC'
      end
    end
  end
end
