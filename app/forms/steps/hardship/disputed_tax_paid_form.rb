module Steps::Hardship
  class DisputedTaxPaidForm < BaseForm
    attribute :disputed_tax_paid, String

    def choices
      DisputedTaxPaid.values.map(&:to_s)
    end
    validates_inclusion_of :disputed_tax_paid, in: proc { |record| record.choices }

    private

    def disputed_tax_paid_value
      DisputedTaxPaid.new(disputed_tax_paid)
    end

    def changed?
      tribunal_case.disputed_tax_paid != disputed_tax_paid_value
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      return true unless changed?

      tribunal_case.update(
        disputed_tax_paid: disputed_tax_paid_value,
        # The following are dependent attributes that need to be reset
        hardship_review_requested: nil,
        hardship_review_status: nil
      )
    end
  end
end
