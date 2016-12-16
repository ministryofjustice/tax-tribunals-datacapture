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
    let(:glimr_new_case_double) {
      instance_double(GlimrNewCase, call!: double(case_reference: 'TC/12345', confirmation_code: 'ABCDEF'))
    }
    let(:payment_double) {
      instance_double(PaymentUrl, call!: double(payment_url: 'http://www.example.com'))
    }

    before do
      allow(GlimrNewCase).to receive(:new).with(tribunal_case).and_return(glimr_new_case_double)
      allow(PaymentUrl).to receive(:new).with(case_reference: 'TC/12345', confirmation_code: 'ABCDEF').and_return(payment_double)
    end

    context 'registering the case into glimr' do
      it 'calls the glimr API' do
        expect(glimr_new_case_double).to receive(:call!)
        subject.call
      end

      it 'should respond to success? with false and have no errors' do
        subject.call
        expect(subject.success?).to eq(true)
        expect(subject.errors).to eq([])
      end

      context 'when there are errors' do
        before do
          allow(glimr_new_case_double).to receive(:call!).and_raise('boom!')
        end

        it 'should respond to success? with false and have errors' do
          subject.call
          expect(subject.success?).to eq(false)
          expect(subject.errors).to eq(['boom!'])
        end
      end
    end

    context 'retrieving the payment url' do
      it 'calls the payment API' do
        expect(payment_double).to receive(:call!)
        subject.call
      end

      it 'should respond to success? with false and have no errors' do
        subject.call
        expect(subject.success?).to eq(true)
        expect(subject.errors).to eq([])
      end

      context 'when there are errors' do
        before do
          allow(payment_double).to receive(:call!).and_raise('boom!')
        end

        it 'should respond to success? with false and have errors' do
          subject.call
          expect(subject.success?).to eq(false)
          expect(subject.errors).to eq(['boom!'])
        end
      end
    end
  end
end
