class CaseType < ValueObject
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

  def initialize(raw_value)
    raise ArgumentError.new('Fee value must be symbol or implicitly convertible') unless raw_value.respond_to?(:to_sym)
    super(raw_value.to_sym)
  end

  def self.values
    VALUES
  end
end
