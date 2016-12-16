class CaseType < ValueObject
  VALUES = [
    AIR_PASSENGER_DUTY         = new(:air_passenger_duty),
    BINGO_DUTY                 = new(:bingo_duty),
    INACCURATE_RETURN_PENALTY  = new(:inaccurate_return_penalty),
    INCOME_TAX                 = new(:income_tax),
    VAT                        = new(:vat),
    OTHER                      = new(:other)
  ].freeze

  def initialize(raw_value)
    raise ArgumentError.new('Case type must be symbol or implicitly convertible') unless raw_value.respond_to?(:to_sym)
    super(raw_value.to_sym)
  end

  def self.values
    VALUES
  end
end
