module Steps::Closure
  class SupportDocumentsForm < BaseForm
    attribute :closure_problems_uploading_documents, Boolean
    attribute :closure_problems_uploading_details, String

    validates_length_of :closure_problems_uploading_details, minimum: 2,
                        if: :closure_problems_uploading_documents

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case

      tribunal_case.update(
        closure_problems_uploading_documents: closure_problems_uploading_documents,
        closure_problems_uploading_details: closure_problems_uploading_details
      )
    end
  end
end
