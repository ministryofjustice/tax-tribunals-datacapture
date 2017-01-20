module Steps::Cost
  class TaxAmountForm < BaseForm
    attribute :tax_amount, String

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      tribunal_case.update(tax_amount: tax_amount)
    end
  end
end
