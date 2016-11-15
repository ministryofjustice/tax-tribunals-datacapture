class ValueObject
  attr_reader :value

  def initialize(raw_value)
    @value = raw_value
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
