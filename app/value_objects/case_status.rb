class CaseStatus < ValueObject
  VALUES = [
    SUBMITTED           = new(:submitted),
    SUBMIT_IN_PROGRESS  = new(:submit_in_progress),
    FIRST_REMINDER_SENT = new(:first_reminder_sent),
    LAST_REMINDER_SENT  = new(:last_reminder_sent)
  ].freeze

  def submitted?
    [SUBMITTED, SUBMIT_IN_PROGRESS].include?(self)
  end
end
