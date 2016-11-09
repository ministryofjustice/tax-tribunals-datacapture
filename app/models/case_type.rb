class CaseType
  VALUES = %w(
    income_tax
    vat
    apn_penalty
    inaccurate_return
    closure_notice
    information_notice
    request_permission_for_review
    other
  )
  INCOME_TAX = 'income_tax'

  def self.values
    VALUES
  end

  def initialize(case_type)
    @case_type = case_type
  end

  attr_reader :case_type

  def ==(other)
    return false unless other.is_a?(self.class)
    other.case_type == case_type
  end

  def to_s
    case_type
  end

  def income_tax?
    case_type == INCOME_TAX
  end
end
