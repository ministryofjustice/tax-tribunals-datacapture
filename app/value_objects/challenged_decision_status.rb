class ChallengedDecisionStatus < ValueObject
  VALUES = [
    RECEIVED              = new(:received),
    PENDING               = new(:pending),
    OVERDUE               = new(:overdue),
    REFUSED               = new(:refused),
    NOT_REQUIRED          = new(:not_required),
    APPEALING_DIRECTLY    = new(:appealing_directly),
    APPEAL_LATE_REJECTION = new(:appeal_late_rejection),
    REVIEW_LATE_REJECTION = new(:review_late_rejection),
  ].freeze

  def self.values
    VALUES
  end

  def pending?
    self == PENDING
  end

  def late_rejection?
    [APPEAL_LATE_REJECTION, REVIEW_LATE_REJECTION].include?(self)
  end
end
