module Steps::Details
  class RepresentativeApprovalForm < BaseForm
    attribute :representative_approval_document, DocumentUpload
    validate :valid_uploaded_file

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      upload_document_if_present && tribunal_case.update(
        representative_approval_file_name: file_name
      )
    end

    def valid_uploaded_file
      return true if representative_approval_document.nil? || representative_approval_document.valid?
      retrieve_document_errors
    end

    def upload_document_if_present
      return true if representative_approval_document.nil?

      representative_approval_document.upload!(document_key: :representative_approval, collection_ref: tribunal_case.files_collection_ref)
      retrieve_document_errors

      errors.empty?
    end

    def retrieve_document_errors
      representative_approval_document.errors.each do |error|
        errors.add(:representative_approval_document, error)
      end
    end

    # If there is a file upload, store the name of the file, otherwise, retrieve any previously
    # uploaded file name from the tribunal_case object (or none if nil).
    def file_name
      representative_approval_document&.file_name || tribunal_case&.representative_approval_file_name
    end
  end
end
