module Steps::Details
  class DocumentsChecklistForm < BaseForm
    attribute :original_notice_provided, Boolean
    attribute :review_conclusion_provided, Boolean
    attribute :having_problems_uploading_documents, Boolean
    attribute :having_problems_uploading_details, String

    validate :documents_uploaded, :letter_checkboxes,
             if: :tribunal_case, unless: :having_problems_uploading_documents

    validates_length_of :having_problems_uploading_details,
                        if: :having_problems_uploading_documents, minimum: 2

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case

      tribunal_case.update(
        original_notice_provided:             original_notice_provided,
        review_conclusion_provided:           review_conclusion_provided,
        having_problems_uploading_documents:  having_problems_uploading_documents,
        having_problems_uploading_details:    having_problems_uploading_details
      )
    end

    def documents_uploaded
      tribunal_case.documents.any? || errors.add(:original_notice_provided, :no_documents)
    end

    def letter_checkboxes
      [
        original_notice_provided,
        review_conclusion_provided
      ].include?(true) || errors.add(:original_notice_provided, :blank)
    end
  end
end
