class CaseStatus < ValueObject
  VALUES = [
    IN_PROGRESS = new(:in_progress),
    SUBMITTED   = new(:submitted)
  ].freeze
end
