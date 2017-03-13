require 'spec_helper'

RSpec.describe Uploader do
  let(:result) { double('result') }
  let(:error) { MojFileUploaderApiClient::RequestError.new('message', 'code', 'body') }

  describe '.add_file' do
    let(:params) { {
      collection_ref: '123',
      document_key: :doc_key,
      filename: 'file_name.doc',
      data: 'data'
    } }

    it 'calls out to MojFileUploaderApiClient with the document key embedded in the filename' do
      expect(MojFileUploaderApiClient).to receive(:add_file).with(
        collection_ref: '123',
        folder: 'doc_key',
        filename: 'file_name.doc',
        data: 'data'
      ).and_return(result)

      expect(described_class.add_file(params)).to eq(result)
    end

    it 'raises InfectedFileError if the uploader raises its own InfectedFileError' do
      expect(MojFileUploaderApiClient).to receive(:add_file).with(
        collection_ref: '123',
        folder: 'doc_key',
        filename: 'file_name.doc',
        data: 'data'
      ).and_raise(MojFileUploaderApiClient::InfectedFileError)

      expect { described_class.add_file(params) }.to raise_error(Uploader::InfectedFileError)
    end

    it 'raises UploaderError if the uploader raises its own RequestError' do
      expect(MojFileUploaderApiClient).to receive(:add_file).with(
        collection_ref: '123',
        folder: 'doc_key',
        filename: 'file_name.doc',
        data: 'data'
      ).and_raise(error)

      expect { described_class.add_file(params) }.to raise_error(Uploader::UploaderError)
    end
  end

  describe '.delete_file' do
    let(:params) { {
      collection_ref: '123',
      document_key: :doc_key,
      filename: 'file_name.doc'
    } }

    it 'calls out to MojFileUploaderApiClient with the document key embedded in the filename' do
      expect(MojFileUploaderApiClient).to receive(:delete_file).with(
        collection_ref: '123',
        folder: 'doc_key',
        filename: 'file_name.doc'
      ).and_return(result)

      expect(described_class.delete_file(params)).to eq(result)
    end

    it 'raises UploaderError if the uploader raises its own RequestError' do
      expect(MojFileUploaderApiClient).to receive(:delete_file).with(
        collection_ref: '123',
        folder: 'doc_key',
        filename: 'file_name.doc'
      ).and_raise(error)

      expect { described_class.delete_file(params) }.to raise_error(Uploader::UploaderError)
    end
  end

  describe '.list_files' do
    let(:files)  { double('Files') }
    let(:result) { { files: files } }
    let(:params) { {
      collection_ref: '123',
      document_key: :doc_key
    } }

    it 'calls out to MojFileUploaderApiClient with the document key embedded in the collection ref' do
      expect(MojFileUploaderApiClient).to receive(:list_files).with(
        collection_ref: '123',
        folder: 'doc_key',
      ).and_return(result)

      expect(described_class.list_files(params)).to eq(files)
    end

    it 'returns an empty array if the uploader raises its own NotFoundError' do
      expect(MojFileUploaderApiClient).to receive(:list_files).with(
        collection_ref: '123',
        folder: 'doc_key',
      ).and_raise(MojFileUploaderApiClient::NotFoundError)

      expect(described_class.list_files(params)).to eq([])
    end

    it 'raises UploaderError if the uploader raises its own RequestError' do
      expect(MojFileUploaderApiClient).to receive(:list_files).with(
        collection_ref: '123',
        folder: 'doc_key',
      ).and_raise(error)

      expect { described_class.list_files(params) }.to raise_error(Uploader::UploaderError)
    end
  end
end
