class PenaltyLevel < ValueObject
  VALUES = [
    PENALTY_LEVEL_1 = new(:penalty_level_1),
    PENALTY_LEVEL_2 = new(:penalty_level_2),
    PENALTY_LEVEL_3 = new(:penalty_level_3)
  ].freeze

  def self.values
    VALUES
  end
end
