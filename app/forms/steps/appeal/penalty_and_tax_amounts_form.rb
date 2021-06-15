module Steps::Appeal
  class PenaltyAndTaxAmountsForm < BaseForm
    attribute :penalty_amount, String
    attribute :tax_amount, String

    validates_numericality_of :tax_amount, greater_than: 0, unless: :unknown_tax_amount_entered?
    validates_numericality_of :penalty_amount, greater_than: 0, unless: :unknown_penalty_amount_entered?

    private

    def unknown_tax_amount_entered?
      tax_amount&.downcase == I18n.t('dictionary.unknown')
    end

    def unknown_penalty_amount_entered?
      penalty_amount&.downcase == I18n.t('dictionary.unknown')
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      tribunal_case.update(
        penalty_amount: penalty_amount,
        tax_amount: tax_amount
      )
    end
  end
end
