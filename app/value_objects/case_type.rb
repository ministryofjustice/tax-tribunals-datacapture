class CaseType < ValueObject
  attr_reader :direct_tax, :ask_dispute_type, :ask_penalty, :ask_hardship
  alias_method :direct_tax?, :direct_tax
  alias_method :ask_dispute_type?, :ask_dispute_type
  alias_method :ask_penalty?, :ask_penalty
  alias_method :ask_hardship?, :ask_hardship

  def self.find_constant(raw_value)
    const_get(raw_value.upcase)
  end

  def initialize(raw_value, direct_tax: false, ask_dispute_type: false, ask_penalty: false, ask_hardship: false)
    raise ArgumentError.new('Case type must be symbol or implicitly convertible') unless raw_value.respond_to?(:to_sym)
    @direct_tax, @ask_dispute_type, @ask_penalty, @ask_hardship = direct_tax, ask_dispute_type, ask_penalty, ask_hardship

    super(raw_value.to_sym)
  end

  def self.direct_tax_properties
    { direct_tax: true, ask_dispute_type: true, ask_penalty: true, ask_hardship: false }
  end

  def self.indirect_tax_properties
    { direct_tax: false, ask_dispute_type: true, ask_penalty: true, ask_hardship: true }
  end

  VALUES = [
    APN_PENALTY                  = new(:apn_penalty,                  direct_tax: false, ask_dispute_type: false, ask_penalty: true,  ask_hardship: false),
    AGGREGATES_LEVY              = new(:aggregates_levy,              indirect_tax_properties),
    AIR_PASSENGER_DUTY           = new(:air_passenger_duty,           indirect_tax_properties),
    ALCOHOLIC_LIQUOR_DUTIES      = new(:alcoholic_liquor_duties,      indirect_tax_properties),
    BINGO_DUTY                   = new(:bingo_duty,                   indirect_tax_properties),
    CAPITAL_GAINS_TAX            = new(:capital_gains_tax,            direct_tax_properties),
    CORPORATION_TAX              = new(:corporation_tax,              direct_tax_properties),
    CLIMATE_CHANGE_LEVY          = new(:climate_change_levy,          indirect_tax_properties),
    CONSTRUCTION_INDUSTRY_SCHEME = new(:construction_industry_scheme, direct_tax_properties),
    CUSTOMS_DUTY                 = new(:customs_duty,                 indirect_tax_properties),
    GAMING_DUTY                  = new(:gaming_duty,                  indirect_tax_properties),
    GENERAL_BETTING_DUTY         = new(:general_betting_duty,         indirect_tax_properties),
    HYDROCARBON_OIL_DUTIES       = new(:hydrocarbon_oil_duties,       indirect_tax_properties),
    INACCURATE_RETURN_PENALTY    = new(:inaccurate_return_penalty,    direct_tax: false, ask_dispute_type: false, ask_penalty: true,  ask_hardship: false),
    INCOME_TAX                   = new(:income_tax,                   direct_tax_properties),
    INFORMATION_NOTICE           = new(:information_notice,           direct_tax: false, ask_dispute_type: true,  ask_penalty: true,  ask_hardship: false),
    INHERITANCE_TAX              = new(:inheritance_tax,              direct_tax_properties),
    INSURANCE_PREMIUM_TAX        = new(:insurance_premium_tax,        indirect_tax_properties),
    LANDFILL_TAX                 = new(:landfill_tax,                 indirect_tax_properties),
    LOTTERY_DUTY                 = new(:lottery_duty,                 indirect_tax_properties),
    NI_CONTRIBUTIONS             = new(:ni_contributions,             direct_tax_properties),
    PETROLEUM_REVENUE_TAX        = new(:petroleum_revenue_tax,        direct_tax_properties),
    POOL_BETTING_DUTY            = new(:pool_betting_duty,            indirect_tax_properties),
    STAMP_DUTIES                 = new(:stamp_duties,                 direct_tax_properties),
    STATUTORY_PAYMENTS           = new(:statutory_payments,           direct_tax_properties),
    STUDENT_LOANS                = new(:student_loans,                direct_tax_properties),
    TOBACCO_PRODUCTS_DUTY        = new(:tobacco_products_duty,        indirect_tax_properties),
    VAT                          = new(:vat,                          indirect_tax_properties),
    OTHER                        = new(:other,                        direct_tax: false, ask_dispute_type: false, ask_penalty: false, ask_hardship: true)
  ].freeze

  def self.values
    VALUES
  end
end
