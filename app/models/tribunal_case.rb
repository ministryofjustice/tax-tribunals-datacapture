class TribunalCase < ApplicationRecord
  def self.what_is_appeal_about_values
    %w(
      income_tax
      vat
      apn_penalty
      inaccurate_return
      closure_notice
      information_notice
      request_permission_for_review
      other
    )
  end
end
