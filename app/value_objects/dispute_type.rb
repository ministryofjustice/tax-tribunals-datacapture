class DisputeType < ValueObject
  VALUES = [
    PAYE_CODING_NOTICE     = new(:paye_coding_notice),
    LATE_RETURN_OR_PAYMENT = new(:late_return_or_payment),
    AMOUNT_OF_TAX_OWED     = new(:amount_of_tax_owed)
  ].freeze

  def initialize(raw_value)
    raise ArgumentError.new('Dispute type must be symbol or implicitly convertible') unless raw_value.respond_to?(:to_sym)
    super(raw_value.to_sym)
  end
end
