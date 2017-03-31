module Steps::Details
  class DocumentsChecklistForm < BaseForm
    attribute :original_notice_provided, Boolean
    attribute :review_conclusion_provided, Boolean
    attribute :having_problems_uploading, Boolean
    attribute :having_problems_uploading_explanation, String

    validate :documents_uploaded, :letter_checkboxes_ticked,
             if: :tribunal_case, unless: :having_problems_uploading

    validates_presence_of :having_problems_uploading_explanation, if: :having_problems_uploading

    def save
      # The validation in #documents_uploaded below checks TribunalCase#documents,
      # which may erroneously return an empty array if the user previously ticked
      # "I'm having trouble" but then unticked it again.
      # This ensures having_problems_uploading is the correct value before validation.
      tribunal_case&.having_problems_uploading = having_problems_uploading

      super
    end

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case

      tribunal_case.update(
        original_notice_provided: original_notice_provided,
        review_conclusion_provided: review_conclusion_provided,
        having_problems_uploading: having_problems_uploading,
        having_problems_uploading_explanation: having_problems_uploading ? having_problems_uploading_explanation : nil
      )
    end

    def documents_uploaded
      tribunal_case.documents(:supporting_documents).any? || errors.add(:original_notice_provided, :no_documents)
    end

    def letter_checkboxes_ticked
      [
        original_notice_provided,
        review_conclusion_provided
      ].include?(true) || errors.add(:original_notice_provided, :blank)
    end
  end
end
