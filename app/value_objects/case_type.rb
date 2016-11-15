class CaseType < ValueObject
  VALUES = [
    INCOME_TAX                    = new(:income_tax),
    VAT                           = new(:vat),
    APN_PENALTY                   = new(:apn_penalty),
    INACCURATE_RETURN             = new(:inaccurate_return),
    CLOSURE_NOTICE                = new(:closure_notice),
    INFORMATION_NOTICE            = new(:information_notice),
    REQUEST_PERMISSION_FOR_REVIEW = new(:request_permission_for_review),
    OTHER                         = new(:other)
  ].freeze

  def initialize(raw_value)
    raise ArgumentError.new('Case type must be symbol or implicitly convertible') unless raw_value.respond_to?(:to_sym)
    super(raw_value.to_sym)
  end

  def self.values
    VALUES
  end
end
