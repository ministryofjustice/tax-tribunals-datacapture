require 'spec_helper'

RSpec.describe Document do
  let(:collection_ref) { '12345' }
  let(:date) { DateTime.parse('Wed, 13 Apr 2022 11:03:21 +0000') }
  let(:attrs) {{ name: '123/foo/test.doc', 
                 collection_ref: collection_ref,
                 last_modified: date }}

  subject { described_class.new(attrs) }

  describe '.new' do
    it 'build a document with all required attributes' do
      expect(subject.collection_ref).to eq('12345')
      expect(subject.name).to eq('test.doc')
    end


    it 'fails if no collection_ref attribute provided' do
      expect { described_class.new(attrs.except(:collection_ref)) }.to raise_exception(KeyError)
    end

    it 'fails if no filename provided' do
      expect { described_class.new(attrs.except(:name)) }.to raise_exception(KeyError)
    end
  end

  describe '#to_param' do
    it 'returns a base64 encoded name' do
      expect(subject.to_param).to eq("dGVzdC5kb2M=\n")
    end
  end

  describe '#encoded_name' do
    it 'returns a base64 encoded name' do
      expect(subject.encoded_name).to eq("dGVzdC5kb2M=\n")
    end
  end

  describe 'collection fetching' do
    before do
      expect(Uploader).to receive(:list_files).with(
        collection_ref: '12345',
        document_key: document_key
      ).and_return(result)
    end

    describe '.for_collection' do
      let(:documents) { described_class.for_collection('12345', document_key: :foo) }
      let(:document_key) { :foo }

      let(:result) { [
        double('uploader', name: '12345/foo/test.doc', properties: {
          last_modified: 'Thu, 14 Apr 2022 11:03:21 +0000' }),
        double('uploader', name: '12345/foo/another.doc', properties: {
          last_modified: 'Wed, 13 Apr 2022 11:03:21 +0000'})
      ] }

      it 'returns the sorted documents' do
        expect(documents.size).to eq(2)
        expect(documents.map(&:name)).to eq(%w(another.doc test.doc))
      end
    end

    describe '.all_for_collection' do
      let(:documents) { described_class.all_for_collection('12345') }
      let(:document_key) { nil }

      let(:result) { [
        double('uploader', name: '12345/supporting_documents/test.doc', properties: {
          last_modified: 'Thu, 14 Apr 2022 11:03:21 +0000'}),
        double('uploader', name: '12345/supporting_documents/another.doc', properties: {
          last_modified: 'Wed, 13 Apr 2022 11:03:21 +0000'}),
        double('uploader', name: '12345/other/test.doc', properties: {
          last_modified: 'Wed, 13 Apr 2022 11:03:21 +0000'}),
        double('uploader', name: '12345/foo/test.doc', properties: {
          last_modified: 'Wed, 13 Apr 2022 11:03:21 +0000'})
      ] }

      it 'returns the sorted documents' do
        expect(documents.keys).to match_array(%i(foo other supporting_documents))

        expect(documents[:foo].size).to eq(1)
        expect(documents[:foo].map(&:name)).to eq(%w(test.doc))
        expect(documents[:other].size).to eq(1)
        expect(documents[:other].map(&:name)).to eq(%w(test.doc))
        expect(documents[:supporting_documents].size).to eq(2)
        expect(documents[:supporting_documents].map(&:name)).to eq(%w(another.doc test.doc))
      end
    end
  end
end
