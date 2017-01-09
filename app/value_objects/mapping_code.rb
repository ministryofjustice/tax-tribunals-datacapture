class MappingCode < ValueObject
  VALUES = [
    APPL_PENALTY_LOW  = new(:appl_penalty_low),
    APPL_PENALTY_MED  = new(:appl_penalty_med),
    APPL_PENALTY_HIGH = new(:appl_penalty_high),
    APPL_PAYECODING   = new(:appl_payecoding),
    APPL_INFONOTICE   = new(:appl_infonotice),
    APPL_OTHER        = new(:appl_other),
    APPN_CLOSEENQUIRY = new(:appn_closeenquiry),
    APPN_OTHER        = new(:appn_other)
  ].freeze

  def to_glimr_str
    to_s.upcase
  end
end
