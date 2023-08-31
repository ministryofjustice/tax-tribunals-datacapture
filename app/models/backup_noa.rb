class BackupNoa < ApplicationRecord
  def self.keep_noa(collection_ref:, folder:, filename:, data:)
    if is_noa?(filename)
      create(
        collection_ref:,
        folder:,
        filename:,
        data:
      )
      Rails.logger.info("[BACKUP_NOA] - saving NOA file #{filename}")
    else
      Rails.logger.info("[BACKUP_NOA] - skipping file #{filename} not a NOA")
    end
  end

  def self.is_noa?(filename)
    filename =~ /^TC_\d{4}_\d*_.*$/
  end

  def self.process
    Rails.logger.info("[BACKUP_NOA] - process started")
    find_each(&method(:re_upload))
    Rails.logger.info("[BACKUP_NOA] - process finished")
  end

  def self.re_upload(backup)
    Uploader.add_file(
      collection_ref: backup.collection_ref,
      document_key: backup.folder,
      filename: backup.filename,
      data: backup.data
    )
    backup.destroy
    Rails.logger.info("[BACKUP_NOA] - file #{backup.filename} uploaded")
  rescue Uploader::UploaderError
    attempts = backup.attempts || 0
    backup.update(attempts: attempts + 1)
  end
end
