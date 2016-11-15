class PenaltyAmount < ValueObject
  VALUES = [
    PENALTY_LEVEL_1 = new(:penalty_level_1),
    PENALTY_LEVEL_2 = new(:penalty_level_2),
    PENALTY_LEVEL_3 = new(:penalty_level_3)
  ].freeze

  def initialize(raw_value)
    raise ArgumentError.new('Penalty amount must be symbol or implicitly convertible') unless raw_value.respond_to?(:to_sym)
    super(raw_value.to_sym)
  end

  def self.values
    VALUES
  end
end
