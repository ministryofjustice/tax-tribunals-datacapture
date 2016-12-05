module Steps::Details
  class GroundsForAppealForm < BaseForm
    attribute :grounds_for_appeal, String
    attribute :grounds_for_appeal_file_name, String
    attribute :grounds_for_appeal_document, UploadedFile

    validates_presence_of :grounds_for_appeal, if: :requires_appeal_text?
    validates_presence_of :grounds_for_appeal_document, if: :requires_appeal_document?
    validate :valid_uploaded_file

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case

      grounds_for_appeal_document&.upload!(
        collection_ref: tribunal_case.files_collection_ref
      )

      tribunal_case.update(
        grounds_for_appeal: grounds_for_appeal,
        grounds_for_appeal_file_name: file_name
      )
    end

    def valid_uploaded_file
      return true if grounds_for_appeal_document.nil? || grounds_for_appeal_document.valid?

      grounds_for_appeal_document.errors.each do |error|
        errors.add(:grounds_for_appeal_document, error)
      end
    end

    def requires_appeal_text?
      grounds_for_appeal_file_name.blank? && grounds_for_appeal_document.blank?
    end

    def requires_appeal_document?
      grounds_for_appeal.blank? && requires_appeal_text?
    end

    def file_name
      grounds_for_appeal_document&.file_name || grounds_for_appeal_file_name
    end
  end
end
