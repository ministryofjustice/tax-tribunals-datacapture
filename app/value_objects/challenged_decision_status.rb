class ChallengedDecisionStatus < ValueObject
  VALUES = [
    RECEIVED = new(:received),
    PENDING  = new(:pending),
    OVERDUE  = new(:overdue)
  ].freeze

  def self.values
    VALUES
  end
end
