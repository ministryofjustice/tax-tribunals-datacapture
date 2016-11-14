class Fee < ValueObject
  def initialize(raw_value)
    raise ArgumentError.new('Fee value must be integer or implicitly convertible') unless raw_value.respond_to?(:to_int)
    super(raw_value.to_int)
  end

  def to_gbp
    (value / 100.0)
  end
end
