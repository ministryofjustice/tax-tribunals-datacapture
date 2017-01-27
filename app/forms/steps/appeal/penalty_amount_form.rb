module Steps::Appeal
  class PenaltyAmountForm < BaseForm
    attribute :penalty_level, String
    attribute :penalty_amount, String

    def self.choices
      PenaltyLevel.values.map(&:to_s)
    end
    validates_inclusion_of :penalty_level, in: choices

    private

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
