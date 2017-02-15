module Steps::Details
  class RepresentativeApprovalForm < BaseForm
    attribute :representative_approval_document, DocumentUpload

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      true
    end
  end
end
