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
        grounds_for_appeal: grounds_for_appeal
      )
    end

    def valid_uploaded_file
      return true if grounds_for_appeal_document.nil? || grounds_for_appeal_document.valid?
      retrieve_document_errors
    end

    def document_provided?
      tribunal_case&.documents(:grounds_for_appeal)&.any? || grounds_for_appeal_document.present?
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
  end
end
