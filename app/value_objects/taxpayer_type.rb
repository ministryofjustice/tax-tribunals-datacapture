class TaxpayerType < ValueObject
  VALUES = [
    INDIVIDUAL = new(:individual),
    COMPANY    = new(:company)
  ].freeze

  def self.values
    VALUES
  end

  def initialize(raw_value)
    raise ArgumentError.new('Taxpayer type must be symbol or implicitly convertible') unless raw_value.respond_to?(:to_sym)
    super(raw_value.to_sym)
  end
end
