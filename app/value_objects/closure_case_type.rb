class ClosureCaseType < ValueObject
  VALUES = [
    CAPITAL_GAINS_TAX_CLOSURE   = new(:capital_gains_tax_closure),
    CORPORATION_TAX_CLOSURE     = new(:corporation_tax_closure),
    INCOME_TAX_CLOSURE          = new(:income_tax_closure),
    PARTNERSHIP_TAX_CLOSURE     = new(:partnership_tax_closure),
    STAMP_DUTY_LAND_TAX_CLOSURE = new(:stamp_duty_land_tax_closure),
  ].freeze

  def self.values
    VALUES
  end
end
