module Steps::Hardship
  class HardshipReasonForm < BaseForm
    include DocumentAttachable

    attribute :hardship_reason, String
    attribute :hardship_reason_document, DocumentUpload

    validates_presence_of :hardship_reason, unless: :document_provided?

    def document_key
      :hardship_reason
    end

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case

      upload_document_if_present && tribunal_case.update(
        hardship_reason: hardship_reason
      )
    end
  end
end
