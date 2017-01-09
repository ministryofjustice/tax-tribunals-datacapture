class ValueObject
  attr_reader :value

  def initialize(raw_value)
    raise ArgumentError.new('Raw value must be symbol or implicitly convertible') unless raw_value.respond_to?(:to_sym)
    @value = raw_value.to_sym
    freeze
  end

  def ==(other)
    other.is_a?(self.class) && other.value == value
  end
  alias_method :===, :==
  alias_method :eql?, :==

  def hash
    [ValueObject, self.class, value].hash
  end

  def to_s
    value.to_s
  end
end
