module Steps::Appeal
  class PenaltyAmountForm < BaseForm
    attribute :penalty_level, String
    attribute :penalty_amount, String

    def self.choices
      PenaltyLevel.names
    end
    validates_inclusion_of :penalty_level, in: choices
    validates_numericality_of :penalty_amount, if: :validation_required?
    validate :amount_in_bounds?, if: :validation_required?

    private

    def validation_required?
      amount_required? && !unknown_entered?
    end

    def amount_in_bounds?
      if amount_too_small?
        amount_too_small_error
      elsif amount_too_large?
        amount_too_large_error
      end
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

    def amount_too_small?
      penalty_amount.to_f <= PenaltyLevel.lower_bound(penalty_level)
    end

    def amount_too_large?
      penalty_amount.to_f > PenaltyLevel.upper_bound(penalty_level)
    end

    def amount_too_small_error
      errors.add(:penalty_amount, I18n.t(
                                    'activemodel.errors.models.steps/appeal/penalty_amount_form.attributes.penalty_amount.too_small'
                                  ))
    end

    def amount_too_large_error
      errors.add(:penalty_amount, I18n.t(
                                    'activemodel.errors.models.steps/appeal/penalty_amount_form.attributes.penalty_amount.too_large'
                                  ))
    end
  end
end
