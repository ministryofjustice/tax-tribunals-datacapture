require 'spec_helper'

RSpec.describe DocumentsSubmittedPresenter do
  subject { described_class.new(tribunal_case) }

  let(:tribunal_case) { instance_double(TribunalCase, grounds_for_appeal: grounds_for_appeal) }
  let(:grounds_for_appeal) { 'foo' }

  describe '#list' do
    it 'should retrieve any uploaded file for the given documents prefix' do
      expect(tribunal_case).to receive(:documents).with(:prefix)
      subject.list(:prefix)
    end
  end

  describe '#grounds_for_appeal_text' do
    context 'when grounds_for_appeal text provided' do
      it 'should return the grounds_for_appeal text' do
        expect(subject.grounds_for_appeal_text).to eq('foo')
      end
    end

    context 'when grounds_for_appeal text is not present' do
      let(:grounds_for_appeal) { nil }

      it 'should return a default text if provided' do
        text = subject.grounds_for_appeal_text(default: 'default text')
        expect(text).to eq('default text')
      end

      it 'should return nil if no default text is provided' do
        text = subject.grounds_for_appeal_text
        expect(text).to be_nil
      end
    end
  end
end
