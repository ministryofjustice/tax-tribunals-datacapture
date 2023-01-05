require 'spec_helper'

RSpec.describe Uploader::AddFile do

  subject { described_class.new(params).call }

  before do
    allow_any_instance_of(Azure::Storage::Blob::BlobService).
      to receive(:create_block_blob).and_return('blob-confirmation')
    allow(ENV).to receive(:fetch).with('AZURE_STORAGE_ACCOUNT').and_return('test')
    allow(ENV).to receive(:fetch).with('AZURE_STORAGE_KEY').and_return('alU+HyX8m8djx4QaCTN3p3QRkTJz+DRKl8+z2BEq+KrYAPm6XhQT/iPPs1WgIgylYS2nn+qDkbqcstHn0A7Xsw==')
    allow(ENV).to receive(:fetch).with('AZURE_STORAGE_CONTAINER').and_return(container)
    allow(ENV).to receive(:fetch).with('AZURE_STORAGE_DO_NOT_SCAN').and_return('test')
    allow(ENV).to receive(:fetch).with('VIRUS_SCANNER_ENABLED', '').and_return('true')
    allow(Clamby).to receive(:safe?).and_return(true)
    allow_any_instance_of(described_class).to receive(:sleep).and_return(nil)
  end

  let(:container) { 'container' }
  let(:collection_ref) { 'collection_ref' }
  let(:document_key) { 'document_key' }
  let(:filename) { 'filename.doc' }
  let(:data) { 'data' }

  let(:params) { {
    collection_ref: collection_ref,
    document_key: document_key,
    filename: filename,
    data: data
  } }

  describe '.upload' do
    it 'calls BlobService.create_block_blob' do
      expect_any_instance_of(
          Azure::Storage::Blob::BlobService).to receive(
          :create_block_blob).with(
        container, # container_name
        'collection_ref/document_key/filename.doc', # blob_name
        'data', # file_data
        { content_type: 'application/msword' }
      ).and_return('result')

      subject
    end

    context 'when AWS raises error' do
      before do
        allow_any_instance_of(Azure::Storage::Blob::BlobService).
          to receive(:create_block_blob).
          and_raise(StandardError)
      end

      it 'logs and raises error' do
        allow(Rails).to receive_message_chain(:logger, :tagged).and_yield
        allow(Rails).to receive_message_chain(:logger, :warn)

        expect { subject }.to raise_error(Uploader::UploaderError)
      end

    end

  end

  describe '.scan_file' do
    context 'with a virus' do
      before do
        expect(Clamby).to receive(:safe?).and_return(false)
      end
      it 'detects viruses' do
        expect{ subject }.to raise_error
      end
    end

    context 'without a virus' do
      before do
        expect(Clamby).to receive(:safe?).and_return(true)
      end
      it 'allow non-virus files to pass' do
        expect{ subject }.not_to raise_error(Uploader::InfectedFileError)
      end
    end
  end

  describe '.content_type' do
    context 'with a valid content type' do      
      it 'does not raise an error' do
        expect{ subject }.not_to raise_error
      end
    end

    context 'with an invalid content type' do
      let(:filename) { 'filename' }
      it 'allow non-virus files to pass' do
        expect{ subject }.to raise_error(Uploader::UploaderError)
      end
    end
  end

  describe '.sanitize_filename' do
    let(:filename) { 'filename;drop table;.doc' }
    it 'sanitizes file names' do
      expect_any_instance_of(
          Azure::Storage::Blob::BlobService).to receive(
          :create_block_blob).with(
        container, # container_name
        'collection_ref/document_key/filenamedroptable.doc', # blob_name
        'data', # file_data
        { content_type: 'application/msword' }
      )
      subject
    end
  end

  describe '.validate_arguments' do
    
    context 'no filename' do
      let(:filename) { nil }
      it 'requires a filename' do
        expect{ subject }.to raise_error(
          Uploader::UploaderError, "Filename must be provided")
      end
    end

    context 'no data' do
      let(:data) { nil }
      it 'requires data' do
        expect{ subject }.to raise_error(
          Uploader::UploaderError, "File data must be provided")
      end
    end
  end

  describe '.repeat_or_raise' do
    it 'if it receives Uploader::UploaderError, it retries the error a '\
        'configurable number of times before re-raising' do
      allow_any_instance_of(described_class).to receive(:sleep)
      expect_any_instance_of(Azure::Storage::Blob::BlobService).
        to receive(:create_block_blob).
        exactly(described_class::UPLOAD_RETRIES+2).and_raise(StandardError)

      expect { subject }.to raise_error(Uploader::UploaderError)
    end
  end

end