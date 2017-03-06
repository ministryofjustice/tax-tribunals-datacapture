module Steps::Closure
  class SupportDocumentsForm < BaseForm
    attribute :having_problems_uploading_documents, Boolean
    attribute :having_problems_uploading_details, String

    validates_presence_of :having_problems_uploading_details, if: :having_problems_uploading_documents

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case

      tribunal_case.update(
        having_problems_uploading_documents: having_problems_uploading_documents,
        having_problems_uploading_details: having_problems_uploading_details
      )
    end
  end
end
