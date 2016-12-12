class ChallengedDecision < ValueObject
  VALUES = [
    YES                = new(:yes),
    NO                 = new(:no),
  ].freeze

  def self.values
    VALUES
  end

  def initialize(raw_value)
    raise ArgumentError.new('Challenged decision must be symbol or implicitly convertible') unless raw_value.respond_to?(:to_sym)
    super(raw_value.to_sym)
  end
end
