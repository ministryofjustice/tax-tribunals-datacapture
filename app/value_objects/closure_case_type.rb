class ClosureCaseType < ValueObject
  VALUES = [
    PERSONAL_RETURN                = new(:personal_return),
    COMPANY_RETURN                 = new(:company_return),
    PARTNERSHIP_RETURN             = new(:partnership_return),
    TRUSTEE_RETURN                 = new(:trustee_return),
    ENTERPRISE_MGMT_INCENTIVES     = new(:enterprise_mgmt_incentives),
    NON_RESIDENT_CAPITAL_GAINS_TAX = new(:non_resident_capital_gains_tax),
    STAMP_DUTY_LAND_TAX_RETURN     = new(:stamp_duty_land_tax_return),
    TRANSACTIONS_IN_SECURITIES     = new(:transactions_in_securities),
    CLAIM_OR_AMENDMENT             = new(:claim_or_amendment),
  ].freeze

  def self.values
    VALUES
  end
end
