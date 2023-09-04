module Steps::Appeal
  class TaxAmountForm < BaseForm
    attribute :tax_amount, String

    validates_numericality_of :tax_amount, greater_than: 0, unless: :unknown_entered?

    private

    def unknown_entered?
      tax_amount&.downcase == I18n.t('dictionary.unknown')
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      tribunal_case.update(tax_amount:)
    end
  end
end
