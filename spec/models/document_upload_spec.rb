require 'spec_helper'

include ActionDispatch::TestProcess

RSpec.describe DocumentUpload do
  let(:file_path) { 'files/image.jpg' }
  let(:content_type) { 'image/jpeg' }
  let(:file) { fixture_file_upload(file_path, content_type) }

  subject { described_class.new(file) }

  context '#errors' do
    it 'should be empty upon initialization' do
      expect(subject.errors).to eq([])
    end
  end

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

      it 'should return false' do
        expect(subject.valid?).to eq(false)
      end

      it 'should have an error' do
        subject.valid?
        expect(subject.errors).to eq([:file_size])
      end
    end

    context 'when file is not valid due to content type' do
      let(:content_type) { 'application/zip' }

      it 'should return false' do
        expect(subject.valid?).to eq(false)
      end

      it 'should have an error' do
        subject.valid?
        expect(subject.errors).to eq([:content_type])
      end
    end

    context 'when file is not valid due to content type' do
      let(:content_type) { 'application/zip' }

      it 'should return false' do
        expect(subject.valid?).to eq(false)
      end

      it 'should have an error' do
        subject.valid?
        expect(subject.errors).to eq([:content_type])
      end
    end
  end

  context '#upload!' do
    it 'should upload the document' do
      expect_any_instance_of(MojFileUploaderApiClient::AddFile).to receive(:call)
      expect(file.tempfile).to receive(:read).and_call_original
      subject.upload!(collection_ref: '123')
    end
  end
end
