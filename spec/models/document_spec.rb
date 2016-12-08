require 'spec_helper'

RSpec.describe Document do
  let(:collection_ref) { '12345' }
  let(:attrs) do
    {
        collection_ref: collection_ref,
        name: 'test.doc',
        last_modified: '2016-12-05T12:20:02.000Z'
    }
  end
  let(:response) { double('Response', body: {collection: '12345', files: [
      {key: '12345/test.doc', title: 'test.doc', last_modified: '2016-12-05T12:20:02.000Z'},
      {key: '12345/another.doc', title: 'another.doc', last_modified: '2016-12-05T12:20:02.000Z'}
  ]}) }

  subject { described_class.new(attrs) }

  describe '#to_param' do
    it 'returns a base64 encoded name' do
      expect(subject.to_param).to eq("dGVzdC5kb2M=\n")
    end
  end

  describe '.for_collection' do
    before do
      expect(MojFileUploaderApiClient::ListFiles).to receive(:new).with(
          collection_ref: collection_ref).and_return(double(call: response))
    end

    context 'without filtering' do
      it 'returns all the documents' do
        documents = described_class.for_collection('12345')
        expect(documents.size).to eq(2)
        expect(documents.map(&:name).sort).to eq(%w(another.doc test.doc))
      end
    end

    context 'with filtering' do
      it 'returns all documents except the filtered ones' do
        documents = described_class.for_collection('12345', filter: ['another.doc'])
        expect(documents.size).to eq(1)
        expect(documents.map(&:name).sort).to eq(['test.doc'])
      end
    end
  end
end
