require 'spec_helper'

include ActionDispatch::TestProcess

RSpec.describe DocumentUpload do
  let(:file_path) { 'files/image.jpg' }
  let(:content_type) { 'image/jpeg' }
  let(:file) { fixture_file_upload(file_path, content_type) }
  let(:document_key) { 'doc_key' }

  subject { described_class.new(file, collection_ref: '123', document_key: document_key) }

  before do
    allow(Uploader).to receive(:list_files).and_return([])
  end

  context 'for a tempfile' do
    let(:file) { Tempfile.new }

    subject { described_class.new(file, document_key: document_key, content_type: 'image/jpeg', filename: 'image.jpg') }

    context '#file_name' do
      it 'should have a file name' do
        expect(subject.file_name).to eq('image.jpg')
      end
    end

    context '#file_size' do
      it 'should have a file size' do
        expect(subject.file_size).to eq(0)
      end
    end

    context '#content_type' do
      it 'should have a content_type' do
        expect(subject.content_type).to eq('image/jpeg')
      end
    end
  end

  context 'for an uploaded file' do
    context '#file_name' do
      it 'should have a file name' do
        expect(subject.file_name).to eq('image.jpg')
      end
    end

    context '#file_size' do
      it 'should have a file size' do
        expect(subject.file_size).to eq(2304)
      end
    end

    context '#content_type' do
      it 'should have a content_type' do
        expect(subject.content_type).to eq('image/jpeg')
      end
    end
  end

  context '#encoded_file_name' do
    it 'should have a base64 encoded file_name' do
      expect(subject.encoded_file_name).to eq("aW1hZ2UuanBn\n")
    end
  end

  context '#errors' do
    it 'should be empty upon initialization' do
      expect(subject.errors).to be_empty
    end
  end

  context '#collection_ref' do
    it 'should have a collection_ref if provided' do
      instance = described_class.new(file, document_key: document_key, collection_ref: '12345')
      expect(instance.collection_ref).to eq('12345')
    end
  end

  context '#to_hash' do
    it 'should expose an attributes hash' do
      expect(subject.to_hash).to eq({name: 'image.jpg', encoded_name: "aW1hZ2UuanBn\n", collection_ref: '123'})
    end
  end

  context '#valid?' do
    context 'when file is valid' do
      it 'should return true' do
        expect(subject.valid?).to eq(true)
      end
    end

    context 'when file is not valid due to file size' do
      before do
        allow(file.tempfile).to receive(:size).and_return(100.megabytes)
      end

      it 'should not be valid' do
        expect(subject).to receive(:add_error).with(:file_size).and_call_original
        expect(subject.valid?).to eq(false)
        expect(subject.errors).not_to be_empty
      end
    end

    context 'when file is not valid due to content type' do
      let(:content_type) { 'application/zip' }

      it 'should not be valid' do
        expect(subject).to receive(:add_error).with(:content_type).and_call_original
        expect(subject.valid?).to eq(false)
        expect(subject.errors).not_to be_empty
      end
    end

    context 'when file is not valid due to non-ascii characters in the name' do
      before do
        allow(subject).to receive(:original_filename).and_return('invalid £ name.txt')
      end

      it 'should not be valid' do
        expect(subject).to receive(:add_error).with(:invalid_characters).and_call_original
        expect(subject.valid?).to eq(false)
        expect(subject.errors).not_to be_empty
      end
    end
  end

  context '#file_name' do
    before do
      allow(subject).to receive(:original_filename).and_return(new_filename)
      allow(Uploader).to receive(:list_files).and_return(uploaded_files)
    end

    context 'existing `image.jpg`, uploading `image.jpg`' do
      let(:new_filename) { 'image.jpg' }
      let(:uploaded_files) { [{collection_ref: '123', name: 'image.jpg'}] }
      it { expect(subject.file_name).to eq('image(1).jpg') }
    end

    context 'existing `image(1).jpg`, uploading `image(1).jpg`' do
      let(:new_filename) { 'image(1).jpg' }
      let(:uploaded_files) { [{collection_ref: '123', name: 'image(1).jpg'}] }
      it { expect(subject.file_name).to eq('image(1)(1).jpg') }
    end

    context 'existing `image.jpg` and `image(1).jpg`, uploading `image.jpg`' do
      let(:new_filename) { 'image.jpg' }
      let(:uploaded_files) { [{collection_ref: '123', name: 'image.jpg'}, {collection_ref: '123', name: 'image(1).jpg'}] }
      it { expect(subject.file_name).to eq('image(2).jpg') }
    end

    context 'existing `image.jpg`, `image(1).jpg` and `image(2).jpg`, uploading `image.jpg`' do
      let(:new_filename) { 'image.jpg' }
      let(:uploaded_files) {
        [
          {collection_ref: '123', name: 'image.jpg'},
          {collection_ref: '123', name: 'image(1).jpg'},
          {collection_ref: '123', name: 'image(2).jpg'}
        ]
      }
      it { expect(subject.file_name).to eq('image(3).jpg') }
    end

    # Although we are filtering out by extension and do not allow files without extension, the following tests cover a
    # theoretical situation uploading files without an extension.
    describe 'files without an extension' do
      context 'existing `image`, uploading `image`' do
        let(:new_filename) { 'image' }
        let(:uploaded_files) { [{collection_ref: '123', name: 'image'}] }
        it { expect(subject.file_name).to eq('image(1)') }
      end

      context 'existing `image.`, uploading `image.`' do
        let(:new_filename) { 'image.' }
        let(:uploaded_files) { [{collection_ref: '123', name: 'image.'}] }
        it { expect(subject.file_name).to eq('image.(1)') }
      end

      context 'existing `.image`, uploading `.image`' do
        let(:new_filename) { '.image' }
        let(:uploaded_files) { [{collection_ref: '123', name: '.image'}] }
        it { expect(subject.file_name).to eq('.image(1)') }
      end
    end
  end

  context '#upload!' do
    before do
      expect(file.tempfile).to receive(:read).and_call_original
    end

    context 'no error' do
      let(:response) { double('Response', error?: false) }

      context 'when the document_key was provided in the initializer' do
        subject { described_class.new(file, document_key: 'foo') }

        it 'should upload the document with that key' do
          expect(Uploader).to receive(:add_file).with(hash_including(document_key: 'foo')).and_return({})

          subject.upload!(collection_ref: '123')
          expect(subject.errors?).to eq(false)
        end
      end

      context 'when the document_key was provided in the upload! params' do
        subject { described_class.new(file) }

        it 'should upload the document with that key' do
          expect(Uploader).to receive(:add_file).with(hash_including(document_key: 'bar')).and_return({})

          subject.upload!(collection_ref: '123', document_key: 'bar')
          expect(subject.errors?).to eq(false)
        end
      end
    end

    context 'with error' do
      context 'response error' do
        let(:error) { double("Upstream error", code: 418, body: "Is it coffee you're looking for?") }
        it 'should upload the document' do
          expect(Uploader).to receive(:add_file).and_raise(Uploader::UploaderError, error)
          expect(subject).to receive(:add_error).with(:response_error).and_call_original
          subject.upload!(collection_ref: '123')
          expect(subject.errors?).to eq(true)
        end
      end

      context 'virus detected error' do
        it 'should upload the document' do
          expect(Uploader).to receive(:add_file).and_raise(Uploader::InfectedFileError)
          expect(subject).to receive(:add_error).with(:virus_detected).and_call_original
          subject.upload!(collection_ref: '123')
          expect(subject.errors?).to eq(true)
        end
      end
    end
  end
end
