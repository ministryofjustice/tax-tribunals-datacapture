require 'spec_helper'

RSpec.describe DocumentsSubmittedPresenter do
  subject { described_class.new(tribunal_case) }

  describe '#supporting_documents' do
    let(:tribunal_case) { instance_double(TribunalCase, having_problems_uploading_documents?: having_problems) }
    let(:documents) { double('documents') }

    before do
      allow(tribunal_case).to receive(:documents).with(:supporting_documents).and_return(documents)
    end

    context 'when no problems uploading documents' do
      let(:having_problems) { false }

      it 'should retrieve any uploaded file for the given documents prefix' do
        expect(subject.supporting_documents).to eq(documents)
      end
    end

    context 'when user was having problems uploading documents' do
      let(:having_problems) { true }

      it 'should return an empty collection' do
        expect(subject.supporting_documents).to be_empty
      end
    end
  end

  describe '#grounds_for_appeal_file_name' do
    let(:tribunal_case) { instance_double(TribunalCase) }

    before do
      allow(tribunal_case).to receive(:documents).with(:grounds_for_appeal).and_return(documents)
    end

    context 'when there is a grounds for appeal file uploaded' do
      let(:documents) { [instance_double(Document, name: 'foo.pdf')] }

      it 'returns the file name' do
        expect(subject.grounds_for_appeal_file_name).to eq('foo.pdf')
      end
    end

    context 'when there is no grounds for appeal document uploaded' do
      let(:documents) { [] }

      it 'returns nil' do
        expect(subject.grounds_for_appeal_file_name).to be_nil
      end
    end
  end

  describe '#hardship_reason_file_name' do
    let(:tribunal_case) { instance_double(TribunalCase) }

    before do
      allow(tribunal_case).to receive(:documents).with(:hardship_reason).and_return(documents)
    end

    context 'when there is a hardship reason file uploaded' do
      let(:documents) { [instance_double(Document, name: 'foo.pdf')] }

      it 'returns the file name' do
        expect(subject.hardship_reason_file_name).to eq('foo.pdf')
      end
    end

    context 'when there is no hardship reason document uploaded' do
      let(:documents) { [] }

      it 'returns nil' do
        expect(subject.hardship_reason_file_name).to be_nil
      end
    end
  end

  describe '#representative_approval_file_name' do
    let(:tribunal_case) { instance_double(TribunalCase) }

    before do
      allow(tribunal_case).to receive(:documents).with(:representative_approval).and_return(documents)
    end

    context 'when there is a rep approval file uploaded' do
      let(:documents) { [instance_double(Document, name: 'foo.pdf')] }

      it 'returns the file name' do
        expect(subject.representative_approval_file_name).to eq('foo.pdf')
      end
    end

    context 'when there is no rep approval document uploaded' do
      let(:documents) { [] }

      it 'returns nil' do
        expect(subject.representative_approval_file_name).to be_nil
      end
    end
  end
end
