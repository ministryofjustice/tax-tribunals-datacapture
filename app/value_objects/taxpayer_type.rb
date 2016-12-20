class TaxpayerType < ValueObject
  VALUES = [
    INDIVIDUAL = new(:individual),
    COMPANY    = new(:company)
  ].freeze

  def self.values
    VALUES
  end
end
