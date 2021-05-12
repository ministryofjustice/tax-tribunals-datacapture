require 'rails_helper'

RSpec.describe BackupNoa, type: :model do
  let(:filename) { 'TC_2020_00934_HulkHogan.pdf' }
  let(:collection_ref) { 'some-ref' }
  let(:folder) { 'folder' }
  let(:data) { 'some data in the file' }
  let(:backup) do
    double(
      collection_ref: collection_ref,
      folder: folder,
      filename: filename,
      data: data,
      attempts: nil
    )
  end

  before do
    allow(Uploader).to receive(:add_file)
    allow(backup).to receive(:destroy)
    allow(backup).to receive(:update)
  end

  describe '.is_noa?' do
    specify { expect(BackupNoa.is_noa?(filename)).to be_truthy }
    specify { expect(BackupNoa.is_noa?('TC_2021_009340_Hulk_Hogan.pdf')).to be_truthy }
    specify { expect(BackupNoa.is_noa?('TC/2021/00934_HulkHogan.pdf')).to be_falsey }
    specify { expect(BackupNoa.is_noa?('some_other_filename.docx')).to be_falsey }
  end

  describe '.keep_noa' do
    subject do
      BackupNoa.keep_noa(
        collection_ref: collection_ref,
        folder: folder,
        filename: filename,
        data: data
      )
    end

    context 'when it is a noa' do
      it 'saves backup' do
        expect(BackupNoa).to receive(:create).with(
                               collection_ref: collection_ref,
                               folder: folder,
                               filename: filename,
                               data: data
                             )
        subject
      end
    end

    context 'when it is not a noa' do
      let(:filename) { 'some_other_filename.docx' }

      it 'does nothing' do
        expect(BackupNoa).not_to receive(:create)
        subject
      end
    end
  end

  describe '.re_upload' do
    subject { BackupNoa.re_upload(backup) }

    it 'invokes Uploader service' do
      expect(Uploader).to receive(:add_file).with(
                            collection_ref: collection_ref,
                            document_key: folder,
                            filename: filename,
                            data: data
                          )
      subject
    end

    it 'delete specified backup after upload' do
      expect(backup).to receive(:destroy)
      subject
    end

    it 'increase attempts count when upload fails' do
      allow(Uploader).to receive(:add_file).and_raise(Uploader::UploaderError, 'test')
      expect(backup).to receive(:update).with(attempts: 1)
      subject
    end
  end

  describe '.process' do
    it 'applies .re_upload to each backup' do
      allow(BackupNoa).to receive(:find_each).and_yield([backup])
      expect(BackupNoa).to receive(:re_upload)
      BackupNoa.process
    end
  end
end
