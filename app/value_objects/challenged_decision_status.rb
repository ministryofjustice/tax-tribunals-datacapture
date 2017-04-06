class ChallengedDecisionStatus < ValueObject
  VALUES = [
    RECEIVED           = new(:received),
    PENDING            = new(:pending),
    OVERDUE            = new(:overdue),
    REFUSED            = new(:refused),
    NOT_REQUIRED       = new(:not_required),
    APPEALING_DIRECTLY = new(:appealing_directly)
  ].freeze

  def self.values
    VALUES
  end

  def pending?
    self == PENDING
  end
end
