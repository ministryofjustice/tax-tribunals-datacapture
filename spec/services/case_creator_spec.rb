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
      instance_double(GlimrNewCase, call!: double(case_reference: 'TC/2017/12345', confirmation_code: 'ABCDEF'))
    }

    before do
      allow(GlimrNewCase).to receive(:new).with(tribunal_case).and_return(glimr_new_case_double)
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

    context 'storing the returned GLiMR case reference' do
      context 'when glimr and payment call was success' do
        it 'should store the case reference in the DB entry' do
          expect(tribunal_case.case_reference).to be_nil
          subject.call
          expect(tribunal_case.case_reference).to eq('TC/2017/12345')
        end

        it 'should mark the case as `submitted`' do
          expect(tribunal_case.case_status).to be_nil
          subject.call
          expect(tribunal_case.case_status).to eq(CaseStatus::SUBMITTED)
        end
      end

      context 'when glimr call fails' do
        it 'should not even reach this point' do
          expect(tribunal_case).not_to receive(:update).with(:case_reference)
          subject.call
        end
      end
    end
  end
end
