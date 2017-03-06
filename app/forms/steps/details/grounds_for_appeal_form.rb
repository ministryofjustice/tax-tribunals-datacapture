module Steps::Details
  class GroundsForAppealForm < BaseForm
    attribute :grounds_for_appeal, String
    attribute :grounds_for_appeal_document, DocumentUpload

    validates_presence_of :grounds_for_appeal, unless: :document_provided?
    validate :valid_uploaded_file

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case

      upload_document_if_present && tribunal_case.update(
        grounds_for_appeal: grounds_for_appeal,
        grounds_for_appeal_file_name: file_name
      )
    end

    def valid_uploaded_file
      return true if grounds_for_appeal_document.nil? || grounds_for_appeal_document.valid?
      retrieve_document_errors
    end

    def document_provided?
      (tribunal_case&.grounds_for_appeal_file_name || grounds_for_appeal_document).present?
    end

    def upload_document_if_present
      return true if grounds_for_appeal_document.nil?

      grounds_for_appeal_document.upload!(document_key: :grounds_for_appeal, collection_ref: tribunal_case.files_collection_ref)
      retrieve_document_errors

      errors.empty?
    end

    def retrieve_document_errors
      grounds_for_appeal_document.errors.each do |error|
        errors.add(:grounds_for_appeal_document, error)
      end
    end

    # If there is a file upload, store the name of the file, otherwise, retrieve any previously
    # uploaded file name from the tribunal_case object (or none if nil).
    def file_name
      grounds_for_appeal_document&.file_name || tribunal_case&.grounds_for_appeal_file_name
    end
  end
end
