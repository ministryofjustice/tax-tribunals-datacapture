class CaseTypeForm < BaseForm
  attribute :case_type, String

  def self.choices
    TribunalCase.case_type_values
  end

  validates_inclusion_of :case_type, in: choices

  private

  def case_type_value
    CaseType.new(case_type)
  end

  def changed?
    tribunal_case.case_type != case_type_value
  end

  def persist!
    raise 'No TribunalCase given' unless tribunal_case
    return unless changed?

    tribunal_case.update(
      case_type: case_type_value,
      # The following are dependent attributes that need to be reset
      dispute_type: nil,
      what_is_penalty_or_surcharge_amount: nil
    )
  end
end
