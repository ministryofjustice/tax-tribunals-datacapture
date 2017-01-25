class MappingCode < ValueObject
  VALUES = [
    APPEAL_INFONOTICE   = new(:appeal_infonotice),
    APPEAL_PAYECODING   = new(:appeal_payecoding),
    APPEAL_PENALTY_LOW  = new(:appeal_penalty_low),
    APPEAL_PENALTY_MED  = new(:appeal_penalty_med),
    APPEAL_PENALTY_HIGH = new(:appeal_penalty_high),
    APPEAL_OTHER        = new(:appeal_other),
    APPN_DECISION_ENQRY = new(:appn_decision_enqry),
    APPN_LATE           = new(:appn_late),
    APPN_OTHER          = new(:appn_other)
  ].freeze

  def to_glimr_str
    to_s.upcase
  end
end
