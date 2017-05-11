module Steps::Challenge
  class DecisionStatusForm < BaseForm
    attribute :challenged_decision_status, String

    validates_inclusion_of :challenged_decision_status, in: proc { |record| record.choices }, if: :tribunal_case

    def choices
      if tribunal_case.case_type.direct_tax?
        [
          ChallengedDecisionStatus::RECEIVED,
          ChallengedDecisionStatus::PENDING,
          ChallengedDecisionStatus::OVERDUE,
          ChallengedDecisionStatus::NOT_REQUIRED,
          ChallengedDecisionStatus::APPEAL_LATE_REJECTION,
          ChallengedDecisionStatus::APPEALING_DIRECTLY
        ]
      elsif restoration_case?
        [
          ChallengedDecisionStatus::RECEIVED,
          ChallengedDecisionStatus::PENDING,
          ChallengedDecisionStatus::OVERDUE,
          ChallengedDecisionStatus::REFUSED,
          ChallengedDecisionStatus::REVIEW_LATE_REJECTION
        ]
      else
        [
          ChallengedDecisionStatus::RECEIVED,
          ChallengedDecisionStatus::PENDING,
          ChallengedDecisionStatus::OVERDUE,
          ChallengedDecisionStatus::REFUSED
        ]
      end.map(&:to_s)
    end

    private

    def restoration_case?
      tribunal_case.case_type.eql?(CaseType::RESTORATION_CASE)
    end

    def challenged_decision_status_value
      ChallengedDecisionStatus.new(challenged_decision_status)
    end

    def changed?
      tribunal_case.challenged_decision_status != challenged_decision_status_value
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      return true unless changed?

      tribunal_case.update(
        challenged_decision_status: challenged_decision_status_value
      )
    end
  end
end
