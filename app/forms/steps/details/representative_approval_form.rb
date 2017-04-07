module Steps::Details
  class RepresentativeApprovalForm < BaseForm
    include DocumentAttachable

    attribute :representative_approval_document, DocumentUpload

    def document_key
      :representative_approval
    end

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      upload_document_if_present
    end
  end
end
