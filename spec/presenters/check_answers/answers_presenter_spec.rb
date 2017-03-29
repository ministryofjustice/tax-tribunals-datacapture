require 'spec_helper'

describe CheckAnswers::AnswersPresenter do
  let(:tribunal_case) { instance_double(TribunalCase, case_reference: case_reference) }
  subject { described_class.new(tribunal_case) }

  describe '#case_reference' do
    let(:case_reference) { 'TC/2017/54321' }

    it 'returns the case reference from the tribunal case' do
      expect(subject.case_reference).to eq('TC/2017/54321')
    end
  end

  describe '#case_reference?' do
    context 'when a case reference is given' do
      let(:case_reference) { 'TC/2017/54321' }

      it 'returns true' do
        expect(subject.case_reference?).to eq(true)
      end
    end

    context 'when no case reference is given' do
      let(:case_reference) { nil }

      it 'returns false' do
        expect(subject.case_reference?).to eq(false)
      end
    end
  end

  describe '#pdf_filename' do
    let(:case_reference) { 'TC/2016/12345' }

    context 'for an organisation' do
      it 'should generate an appropriate file name' do
        expect(tribunal_case).to receive(:taxpayer_individual_first_name).and_return(nil)
        expect(tribunal_case).to receive(:taxpayer_individual_last_name).and_return(nil)
        expect(tribunal_case).to receive(:taxpayer_organisation_name).and_return('CPS')

        expect(subject.pdf_filename).to eq('TC_2016_12345_CPS')
      end
    end

    context 'for an individual' do
      it 'should generate an appropriate file name' do
        expect(tribunal_case).to receive(:taxpayer_individual_first_name).and_return('Shirley')
        expect(tribunal_case).to receive(:taxpayer_individual_last_name).and_return('Schmidt')
        expect(tribunal_case).to receive(:taxpayer_organisation_name).and_return(nil)

        expect(subject.pdf_filename).to eq('TC_2016_12345_ShirleySchmidt')
      end
    end
  end
end
