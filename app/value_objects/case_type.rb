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

  VALUES = [
    AIR_PASSENGER_DUTY         = new(:air_passenger_duty,        direct_tax: false, ask_dispute_type: true,  ask_penalty: true,  ask_hardship: true),
    BINGO_DUTY                 = new(:bingo_duty,                direct_tax: false, ask_dispute_type: true,  ask_penalty: true,  ask_hardship: true),
    INACCURATE_RETURN_PENALTY  = new(:inaccurate_return_penalty, direct_tax: false, ask_dispute_type: false, ask_penalty: true,  ask_hardship: false),
    INCOME_TAX                 = new(:income_tax,                direct_tax: true,  ask_dispute_type: true,  ask_penalty: true,  ask_hardship: false),
    VAT                        = new(:vat,                       direct_tax: false, ask_dispute_type: true,  ask_penalty: true,  ask_hardship: true),
    OTHER                      = new(:other,                     direct_tax: false, ask_dispute_type: false, ask_penalty: false, ask_hardship: true)
  ].freeze

  def self.values
    VALUES
  end
end
