module Steps::Details
  class LetterUploadForm < BaseForm
    include DocumentAttachable

    attribute :supporting_letter_document, DocumentUpload
    attribute :having_problems_uploading, Boolean
    attribute :having_problems_uploading_explanation, String

    validate :check_document_presence, unless: :having_problems_uploading
    validates_presence_of :having_problems_uploading_explanation, if: :having_problems_uploading

    def save
      # The validation in #documents_uploaded below checks TribunalCase#documents,
      # which may erroneously return an empty array if the user previously ticked
      # "I'm having trouble" but then unticked it again.
      # This ensures having_problems_uploading is the correct value before validation.
      tribunal_case&.having_problems_uploading = having_problems_uploading
      super
    end

    def document_key
      :supporting_letter
    end

    def document_type
      case tribunal_case.challenged_decision_status
      when ChallengedDecisionStatus::RECEIVED
        :review_conclusion_letter
      when ChallengedDecisionStatus::APPEAL_LATE_REJECTION
        :late_appeal_refusal_letter
      when ChallengedDecisionStatus::REVIEW_LATE_REJECTION
        :late_review_refusal_letter
      else
        :original_notice_letter
      end
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
