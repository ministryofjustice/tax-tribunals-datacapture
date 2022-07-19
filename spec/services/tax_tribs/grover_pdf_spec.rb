require 'spec_helper'

RSpec.describe TaxTribs::GroverPdf do
  let(:tribunal_case) {
    TribunalCase.create(case_reference: 'TC/2016/12345')
  }


  context 'for Appeal PDFs' do
    let(:controller_name) { AppealCasesController.name }
    subject { described_class.new(tribunal_case, 'ABC', controller_name) }

    context 'when Grover succeeds' do
      before do
        expect(Grover).to receive_message_chain(:new, :to_pdf).and_return('ABC')
      end

      it 'should generate the PDF' do
        expect(subject.generate).to eq 'ABC'
      end
    end

    context 'when Grover crashes the server' do
      before do
        expect(Grover).to receive(:new).and_raise(StandardError)
      end
      it 'should mark the tribunal case as attempted' do
        described_class.
          new(tribunal_case, 'ABC', controller_name, true)
          .generate
        expect(tribunal_case.pdf_generation_status).to eq(
          'APPEAL_ATTEMPT'
        )
      end
    end

    context 'when Grover raises an error' do
      before do
        expect(Grover).to receive(:new).and_raise(StandardError)
      end
      it 'should mark the tribunal case as failed' do
        subject.generate
        expect(tribunal_case.pdf_generation_status).to eq(
          'APPEAL_FAILED'
        )
      end
    end

  end

  context 'for Closure PDFs' do
    let(:controller_name) { ClosureCasesController.name }
    subject { described_class.new(tribunal_case, 'ABC', controller_name) }

    context 'when Grover succeeds' do
      before do
        expect(Grover).to receive_message_chain(:new, :to_pdf).and_return('ABC')
      end

      it 'should generate the PDF' do
        expect(subject.generate).to eq 'ABC'
      end
    end

    context 'when Grover crashes the server' do
      before do
        expect(Grover).to receive(:new).and_raise(StandardError)
      end
      it 'should mark the tribunal case as attempted' do
        described_class.new(tribunal_case, 'ABC', controller_name, true).generate
        expect(tribunal_case.pdf_generation_status).to eq(
          'CLOSURE_ATTEMPT'
        )
      end
    end

    context 'when Grover raises an error' do
      before do
        expect(Grover).to receive(:new).and_raise(StandardError)
      end
      it 'should mark the tribunal case as failed' do
        subject.generate
        expect(tribunal_case.pdf_generation_status).to eq(
          'CLOSURE_FAILED'
        )
      end
    end

  end

end
