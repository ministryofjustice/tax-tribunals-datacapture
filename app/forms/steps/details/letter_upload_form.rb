module Steps::Details
  class LetterUploadForm < BaseForm
    include DocumentAttachable

    attribute :having_problems_uploading, Boolean
    attribute :having_problems_uploading_explanation, String

    validate :check_document_presence, unless: :having_problems_uploading
    validates_presence_of :having_problems_uploading_explanation, if: :having_problems_uploading

    def initialize(*)
      # We add dynamically the document attribute to the attributes set, as only
      # at runtime we know the route the user took on the decision tree
      attribute_set << Virtus::Attribute.build(DocumentUpload, name: document_attribute)
      super
    end

    def save
      # The validation in #documents_uploaded below checks TribunalCase#documents,
      # which may erroneously return an empty array if the user previously ticked
      # "I'm having trouble" but then unticked it again.
      # This ensures having_problems_uploading is the correct value before validation.
      tribunal_case&.having_problems_uploading = having_problems_uploading
      super
    end

    # TODO: the type of letter to be uploaded will depend on challenge question answers
    def document_key
      :original_notice_letter
      # :review_conclusion_letter
      # :late_review_refusal_letter
      # :late_appeal_refusal_letter
    end

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case

      upload_document_if_present && tribunal_case.update(
        having_problems_uploading: having_problems_uploading,
        having_problems_uploading_explanation: having_problems_uploading ? having_problems_uploading_explanation : nil
      )
    end
  end
end
