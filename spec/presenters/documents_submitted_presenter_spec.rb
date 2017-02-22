require 'spec_helper'

RSpec.describe DocumentsSubmittedPresenter do
  subject { described_class.new(tribunal_case) }

  let(:tribunal_case) { instance_double(TribunalCase, grounds_for_appeal: grounds_for_appeal) }
  let(:grounds_for_appeal) { 'foo' }

  describe '#list' do
    it 'should retrieve any uploaded file' do
      expect(tribunal_case).to receive(:documents).with(:supporting_documents)
      subject.list
    end
  end

  describe '#grounds_for_appeal_text' do
    context 'when grounds_for_appeal text provided' do
      it 'should return the grounds_for_appeal text' do
        expect(subject.grounds_for_appeal_text).to eq('foo')
      end
    end

    context 'when grounds_for_appeal text is nil' do
      let(:grounds_for_appeal) { nil }

      it 'should return a default text' do
        text = subject.grounds_for_appeal_text(default: 'default text')
        expect(text).to eq('default text')
      end
    end

    context 'when grounds_for_appeal text is blank' do
      let(:grounds_for_appeal) { '' }

      it 'should return a default text' do
        text = subject.grounds_for_appeal_text(default: 'default text')
        expect(text).to eq('default text')
      end
    end
  end
end
