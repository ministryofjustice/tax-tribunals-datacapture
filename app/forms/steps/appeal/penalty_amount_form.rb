module Steps::Appeal
  class PenaltyAmountForm < BaseForm
    attribute :penalty_level, String
    attribute :penalty_amount, String

    def self.choices
      PenaltyLevel.values.map(&:to_s)
    end
    validates_inclusion_of :penalty_level, in: choices
    validates_presence_of :penalty_amount, if: :amount_required?

    private

    def amount_required?
      [
        PenaltyLevel::PENALTY_LEVEL_2.to_s,
        PenaltyLevel::PENALTY_LEVEL_3.to_s
      ].include?(penalty_level)
    end

    def penalty_level_value
      PenaltyLevel.new(penalty_level)
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      tribunal_case.update(
        penalty_level: penalty_level_value,
        penalty_amount: penalty_amount
      )
    end
  end
end
