require 'spec_helper'

RSpec.describe Uploader do
  let(:result) { double('result') }
  let(:error) { MojFileUploaderApiClient::RequestError.new('message', 'code', 'body') }
  let(:another_error) { StandardError.new('boom!') }

  describe '.add_file' do
    let(:filename) { 'file_name.doc' }
    let(:params) { {
      collection_ref: '123',
      document_key: :doc_key,
      filename: filename,
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
      expect(MojFileUploaderApiClient).to receive(:add_file).and_raise(MojFileUploaderApiClient::InfectedFileError)

      expect { described_class.add_file(params) }.to raise_error(Uploader::InfectedFileError)
    end

    it 'raises UploaderError if the uploader raises an unrecognized exception' do
      expect(MojFileUploaderApiClient).to receive(:add_file).at_least(:once).and_raise(another_error)

      expect { described_class.add_file(params) }.to raise_error(Uploader::UploaderError, 'boom!')
    end

    it 'raises UploaderError with body and code if the uploader raises its own RequestError' do
      expect(MojFileUploaderApiClient).to receive(:add_file).at_least(:once).and_raise(error)

      expect { described_class.add_file(params) }.to raise_error(Uploader::UploaderError, 'message - (code) body')
    end

    it 'if it receives UploaderError, it retries the error a configurable number of times before re-raising' do
      expect(MojFileUploaderApiClient).to receive(:add_file).at_least(described_class::UPLOAD_RETRIES).and_raise(error)

      expect { described_class.add_file(params) }.to raise_error(Uploader::UploaderError)
    end

    it 'it it retries an upload, it sleeps once second longer between each retry' do
      allow(MojFileUploaderApiClient).to receive(:add_file).and_raise(error)
      expect(described_class).to receive(:sleep).once.with(0)
      expect(described_class).to receive(:sleep).once.with(1)
      expect(described_class).to receive(:sleep).once.with(2)

      expect { described_class.add_file(params) }.to raise_error(Uploader::UploaderError)
    end

    context 'when filename is a Notice of Appeal' do
      let(:filename) { 'TC_2022_000753_hulk_hogan.pdf' }
      it 'keeps the notice of appeal when upload fails and is abandoned' do
        allow(MojFileUploaderApiClient).to receive(:add_file).and_raise(error)

        expect(BackupNoa).to receive(:keep_noa).with(
                               collection_ref: params[:collection_ref],
                               folder: params[:document_key].to_s,
                               filename: filename,
                               data: params[:data]
                             )
        expect { described_class.add_file(params) }.not_to raise_error(Uploader::UploaderError)
      end
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
