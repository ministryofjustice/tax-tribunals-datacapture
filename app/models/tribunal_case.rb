class TribunalCase < ApplicationRecord
  WHAT_IS_APPEAL_ABOUT_VALUES = %w(
    income_tax
    vat
    apn_penalty
    inaccurate_return
    closure_notice
    information_notice
    request_permission_for_review
    other
  )
  APPEAL_ABOUT_INCOME_TAX = 'income_tax'

  def self.what_is_appeal_about_values
    WHAT_IS_APPEAL_ABOUT_VALUES
  end
end
