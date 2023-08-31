module CheckAnswers
  class DocumentsSubmittedAnswer < Answer
    attr_reader :documents

    def initialize(question, documents, change_path: nil)
      super(question, documents, change_path:)
      @documents = documents
    end

    # Used by Rails to determine which partial to render
    def to_partial_path
      'documents_submitted_row'
    end
  end
end
