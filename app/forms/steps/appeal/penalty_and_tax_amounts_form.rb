module Steps::Appeal
  class PenaltyAndTaxAmountsForm < BaseForm
    attribute :penalty_amount, String
    attribute :tax_amount, String

    validates_presence_of :penalty_amount, :tax_amount

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
