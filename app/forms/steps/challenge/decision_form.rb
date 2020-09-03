module Steps::Challenge
  class DecisionForm < BaseForm
    attribute :challenged_decision, String

    def self.choices
      ChallengedDecision.values
    end

    validates_inclusion_of :challenged_decision, in: choices.map(&:to_s)

    def heading_translation_key
      if tribunal_case.case_type.direct_tax?
        '.heading_direct'
      else
        '.heading_indirect'
      end
    end

    private

    def challenged_decision_value
      ChallengedDecision.new(challenged_decision)
    end

    def changed?
      tribunal_case.challenged_decision != challenged_decision_value
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      return true unless changed?

      tribunal_case.update(
        challenged_decision: challenged_decision_value,
        # The following are dependent attributes that need to be reset
        challenged_decision_status: nil,
        dispute_type: nil,
        dispute_type_other_value: nil,
        penalty_level: nil,
        penalty_amount: nil,
        tax_amount: nil
      )
    end
  end
end
