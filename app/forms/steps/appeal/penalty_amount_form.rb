module Steps::Appeal
  class PenaltyAmountForm < BaseForm
    attribute :penalty_level, String
    attribute :penalty_amount, String

    def self.choices
      PenaltyLevel.values.map(&:to_s)
    end
    validates_inclusion_of :penalty_level, in: choices
    validates_numericality_of :penalty_amount, greater_than: 20_000, if: :validation_required?

    private

    def validation_required?
      amount_required? && !unknown_entered?
    end

    def unknown_entered?
      penalty_amount&.downcase == I18n.t('dictionary.unknown')
    end

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
