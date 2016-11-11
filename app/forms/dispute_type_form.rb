class DisputeTypeForm < BaseForm
  attribute :dispute_type, String

  validates_inclusion_of :dispute_type, in: proc { |record| record.choices }

  def choices
    if include_paye_coding_notice?
      %w(
        late_return_or_payment
        amount_of_tax_owed
        paye_coding_notice
      )
    else
      %w(
        late_return_or_payment
        amount_of_tax_owed
      )
    end
  end

  def case_challenged?
    tribunal_case.challenged_decision
  end

  private

  def include_paye_coding_notice?
    tribunal_case&.case_type&.income_tax?
  end

  def changed?
    tribunal_case.dispute_type != dispute_type
  end

  def persist!
    raise 'No TribunalCase given' unless tribunal_case
    return unless changed?

    tribunal_case.update(
      dispute_type: dispute_type,
      # The following are dependent attributes that need to be reset
      penalty_amount: nil
    )
  end
end
