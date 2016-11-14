class Fee
  attr_reader :value

  def initialize(raw_value)
    raise ArgumentError.new('Fee value must be integer or implicitly convertible') unless raw_value.respond_to?(:to_int)
    @value = raw_value.to_int
    freeze
  end

  def to_s
    value.to_s
  end

  def to_gbp
    (value / 100.0)
  end

  def ==(other)
    other.is_a?(self.class) && self.value == other.value
  end
end
