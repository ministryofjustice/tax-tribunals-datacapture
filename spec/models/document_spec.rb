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

  describe '.new' do
    it 'build a document with all required attributes' do
      document = described_class.new(collection_ref: '12345', name: 'test.doc', last_modified: '2016-12-05T12:20:02.000Z')
      expect(document.collection_ref).to eq('12345')
      expect(document.name).to eq('test.doc')
      expect(document.last_modified).to eq('2016-12-05T12:20:02.000Z')
    end

    it 'accepts name or title attributes' do
      document = described_class.new(collection_ref: '12345', title: 'test.doc', last_modified: '2016-12-05T12:20:02.000Z')
      expect(document.title).to eq('test.doc')
      expect(document.name).to eq('test.doc')
    end

    it 'accepts missing last_modified attributes' do
      document = described_class.new(collection_ref: '12345', title: 'test.doc')
      expect(document.title).to eq('test.doc')
      expect(document.last_modified).to be_nil
    end

    it 'fails if no collection_ref attribute provided' do
      expect { described_class.new(title: 'test.doc') }.to raise_exception(KeyError)
    end

    it 'fails if no name nor title attribute provided' do
      expect { described_class.new(collection_ref: '12345') }.to raise_exception(KeyError)
    end
  end

  describe '#to_param' do
    it 'uses the encoded name' do
      expect(subject).to receive(:encoded_name)
      subject.to_param
    end
  end

  describe '#encoded_name' do
    it 'returns a base64 encoded name' do
      expect(subject.encoded_name).to eq("dGVzdC5kb2M=\n")
    end
  end

  describe '.for_collection' do
    before do
      expect(MojFileUploaderApiClient::ListFiles).to receive(:new).with(
          collection_ref: collection_ref).and_return(double(call: response))
    end

    context 'when no files element found' do
      let(:response) { double('Response', body: {}) }

      it 'returns an empty array' do
        documents = described_class.for_collection('12345')
        expect(documents).to eq([])
      end
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
