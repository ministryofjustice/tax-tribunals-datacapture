module Steps::Hardship
  class HardshipReasonForm < BaseForm
    attribute :hardship_reason, String
    attribute :hardship_reason_document, DocumentUpload

    validates_presence_of :hardship_reason, unless: :document_provided?
    validate :valid_uploaded_file

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      upload_document_if_present && tribunal_case.update(
        hardship_reason: hardship_reason
      )
    end

    def valid_uploaded_file
      return true if hardship_reason_document.nil? || hardship_reason_document.valid?
      retrieve_document_errors
    end

    def document_provided?
      tribunal_case&.documents(:hardship_reason)&.any? || hardship_reason_document.present?
    end

    def upload_document_if_present
      return true if hardship_reason_document.nil?

      hardship_reason_document.upload!(document_key: :hardship_reason, collection_ref: tribunal_case.files_collection_ref)
      retrieve_document_errors

      errors.empty?
    end

    def retrieve_document_errors
      hardship_reason_document.errors.each do |error|
        errors.add(:hardship_reason_document, error)
      end
    end
  end
end
