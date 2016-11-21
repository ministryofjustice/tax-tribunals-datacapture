class InTime < ValueObject
  VALUES = [
    YES    = new(:yes),
    NO     = new(:no),
    UNSURE = new(:unsure)
  ].freeze

  def initialize(raw_value)
    raise ArgumentError.new('In time must be symbol or implicitly convertible') unless raw_value.respond_to?(:to_sym)
    super(raw_value.to_sym)
  end

  def self.values
    VALUES
  end
end
