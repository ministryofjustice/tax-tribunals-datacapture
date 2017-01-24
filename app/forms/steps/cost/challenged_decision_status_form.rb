module Steps::Cost
  class ChallengedDecisionStatusForm < BaseForm
    attribute :challenged_decision_status, String

    def self.choices
      ChallengedDecisionStatus.values.map(&:to_s)
    end
    validates_inclusion_of :challenged_decision_status, in: choices

    private

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
