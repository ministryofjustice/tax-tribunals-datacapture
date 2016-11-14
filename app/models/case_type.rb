class CaseType
  def initialize(raw_value)
    @value = raw_value.to_sym
    freeze
  end

  VALUES = [
    INCOME_TAX                    = self.new(:income_tax),
    VAT                           = self.new(:vat),
    APN_PENALTY                   = self.new(:apn_penalty),
    INACCURATE_RETURN             = self.new(:inaccurate_return),
    CLOSURE_NOTICE                = self.new(:closure_notice),
    INFORMATION_NOTICE            = self.new(:information_notice),
    REQUEST_PERMISSION_FOR_REVIEW = self.new(:request_permission_for_review),
    OTHER                         = self.new(:other)
  ].freeze

  def self.values
    VALUES
  end

  attr_reader :value

  def ==(other)
    other.is_a?(self.class) && other.value == value
  end
  alias_method :===, :==

  def to_s
    value.to_s
  end
end
