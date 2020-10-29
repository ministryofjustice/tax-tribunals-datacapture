module Steps::Details
  class LetterUploadForm < BaseForm
    include DocumentAttachable

    attribute :supporting_letter_document, DocumentUpload
    attribute :having_problems_uploading, Boolean
    attribute :having_problems_uploading_explanation, String

    validate :check_document_presence, unless: :having_problems_uploading
    validates_presence_of :having_problems_uploading_explanation, if: :having_problems_uploading

    def save
      self.having_problems_uploading = having_problems_uploading ? true : false
      # The validation in #documents_uploaded below checks TribunalCase#documents,
      # which may erroneously return an empty array if the user previously ticked
      # "I'm having trouble" but then unticked it again.
      # This ensures having_problems_uploading is the correct value before validation.
      tribunal_case&.having_problems_uploading = having_problems_uploading
      super
    end

    def document_key
      :supporting_letter
    end

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case

      upload_document_if_present && tribunal_case.update(
        having_problems_uploading: having_problems_uploading,
        having_problems_uploading_explanation: having_problems_uploading ? having_problems_uploading_explanation : nil
      )
    end
  end
end
