class MappingCode < ValueObject
  VALUES = [
    TAXAMOUNTDISPUTE    = new(:taxamountdispute),
    TAXPENALTYLOW       = new(:taxpenaltylow),
    TAXPENALTYMED       = new(:taxpenaltymed),
    TAXPENALTYHIGH      = new(:taxpenaltyhigh),
    PAYECODING          = new(:payecoding),
    ADVPAYNOTICEPENALTY = new(:advpaynoticepenalty),
    INFONOTICEPENALTY   = new(:infonoticepenalty),
    INACCURATERETURN    = new(:inaccuratereturn),
    APPNTOCLOSE         = new(:appntoclose),
    REQUESTREVIEW       = new(:requestreview),
    APPNINFONOTICE      = new(:appninfonotice),
    OTHERAPPEAL         = new(:otherappeal),
    OTHERAPPLICATION    = new(:otherapplication)
  ].freeze

  def to_glimr_str
    to_s.upcase
  end
end
