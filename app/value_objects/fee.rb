class Fee < ValueObject
  def initialize(raw_value)
    raise ArgumentError.new('Fee value must be symbol or implicitly convertible') unless raw_value.respond_to?(:to_sym)
    super(raw_value.to_sym)
  end

  def to_gbp
    GlimrFees.fee_amount(self) / 100.0
  end
end
