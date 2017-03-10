require 'spec_helper'

RSpec.describe DocumentsSubmittedPresenter do
  subject { described_class.new(tribunal_case) }

  describe '#list' do
    let(:tribunal_case) { instance_double(TribunalCase, having_problems_uploading_documents?: having_problems) }

    context 'when no problems uploading documents' do
      let(:having_problems) { false }

      it 'should retrieve any uploaded file for the given documents prefix' do
        expect(tribunal_case).to receive(:documents).with(:prefix)
        subject.list(:prefix)
      end
    end

    context 'when user was having problems uploading documents' do
      let(:having_problems) { true }

      it 'should return an empty collection' do
        expect(tribunal_case).not_to receive(:documents).with(:prefix)
        expect(subject.list(:prefix)).to eq([])
      end
    end
  end

  describe '#text_value_for' do
    context 'when text is present for the given document prefix' do
      let(:tribunal_case) { instance_double(TribunalCase, grounds_for_appeal: 'foo', hardship_reason: 'bar') }

      it { expect(subject.text_value_for(:grounds_for_appeal)).to eq('foo') }
      it { expect(subject.text_value_for(:hardship_reason)).to eq('bar') }
    end

    context 'when text is not present for the given document prefix' do
      let(:tribunal_case) { instance_double(TribunalCase, grounds_for_appeal: nil, hardship_reason: nil) }

      it { expect(subject.text_value_for(:grounds_for_appeal)).to be_nil }
      it { expect(subject.text_value_for(:hardship_reason)).to be_nil }
    end
  end
end
