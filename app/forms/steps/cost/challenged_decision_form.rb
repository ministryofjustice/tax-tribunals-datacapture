module Steps::Cost
  class ChallengedDecisionForm < BaseForm
    attribute :challenged_decision, String

    def self.choices
      ChallengedDecision.values.map(&:to_s)
    end

    validates_inclusion_of :challenged_decision, in: choices

    private

    def challenged_decision_value
      ChallengedDecision.new(challenged_decision)
    end

    def changed?
      tribunal_case.challenged_decision != challenged_decision_value
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      return unless changed?

      tribunal_case.update(
        challenged_decision: challenged_decision_value,
        # The following are dependent attributes that need to be reset
        case_type: nil,
        dispute_type: nil,
        penalty_amount: nil
      )
    end
  end
end
