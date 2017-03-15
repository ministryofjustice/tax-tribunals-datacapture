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
  let(:result) { [
      { key: '12345/test.doc', title: 'test.doc', last_modified: '2016-12-05T12:24:02.000Z' },
      { key: '12345/another.doc', title: 'another.doc', last_modified: '2016-12-05T12:20:02.000Z' }
    ] }

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
    it 'returns a base64 encoded name' do
      expect(subject.to_param).to eq("dGVzdC5kb2M=\n")
    end
  end

  describe '#encoded_name' do
    it 'returns a base64 encoded name' do
      expect(subject.encoded_name).to eq("dGVzdC5kb2M=\n")
    end
  end

  describe '.for_collection' do
    before do
      expect(Uploader).to receive(:list_files).with(
        collection_ref: '12345',
        document_key: :foo
      ).and_return(result)
    end

    it 'returns the sorted documents' do
      documents = described_class.for_collection('12345', document_key: :foo)
      expect(documents.size).to eq(2)
      expect(documents.map(&:name)).to eq(%w(another.doc test.doc))
    end
  end
end
