module Steps::Cost
  class PenaltyAndTaxAmountsForm < BaseForm
    attribute :penalty_amount, String
    attribute :tax_amount, String

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      tribunal_case.update(
        penalty_amount: penalty_amount,
        tax_amount: tax_amount
      )
    end
  end
end
