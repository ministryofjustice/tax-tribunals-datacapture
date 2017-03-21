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
end
