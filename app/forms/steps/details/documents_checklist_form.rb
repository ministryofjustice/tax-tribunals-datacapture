module Steps::Details
  class DocumentsChecklistForm < BaseForm
    attribute :original_notice_provided, Boolean
    attribute :review_conclusion_provided, Boolean
    attribute :additional_documents_provided, Boolean
    attribute :additional_documents_info, String
    attribute :having_problems_uploading_documents, Boolean

    validates_presence_of :original_notice_provided,
                          :review_conclusion_provided, in: [true], unless: :having_problems_uploading_documents
    validates_length_of   :additional_documents_info, minimum: 5, if: :additional_documents_provided
    validates_absence_of  :additional_documents_info, unless: :additional_documents_provided
    validate              :documents_uploaded, unless: :having_problems_uploading_documents

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case

      tribunal_case.update(
        original_notice_provided:             original_notice_provided,
        review_conclusion_provided:           review_conclusion_provided,
        additional_documents_provided:        additional_documents_provided,
        additional_documents_info:            additional_documents_info,
        having_problems_uploading_documents:  having_problems_uploading_documents
      )
    end

    def documents_uploaded
      if tribunal_case && tribunal_case.documents.empty?
        errors.add(:original_notice_provided, :no_documents)
      end
    end
  end
end
