module Steps::Lateness
  class LatenessReasonForm < BaseForm
    include DocumentAttachable

    attribute :lateness_reason, String
    attribute :lateness_reason_document, DocumentUpload

    validates_presence_of :lateness_reason, unless: :document_provided?

    def document_key
      :lateness_reason
    end

    def lateness_unknown?
      tribunal_case.in_time == InTime::UNSURE
    end

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case

      upload_document_if_present && tribunal_case.update(
        lateness_reason: lateness_reason
      )
    end
  end
end
