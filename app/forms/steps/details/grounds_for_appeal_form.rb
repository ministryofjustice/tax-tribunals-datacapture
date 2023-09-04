module Steps::Details
  class GroundsForAppealForm < BaseForm
    include DocumentAttachable

    attribute :grounds_for_appeal, String
    attribute :grounds_for_appeal_document, DocumentUpload

    validates_presence_of :grounds_for_appeal, unless: :document_provided?

    def document_key
      :grounds_for_appeal
    end

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case

      upload_document_if_present && tribunal_case.update(
        grounds_for_appeal:
      )
    end
  end
end
