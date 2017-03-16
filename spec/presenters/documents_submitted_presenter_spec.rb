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
end
