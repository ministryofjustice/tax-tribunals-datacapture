class RepresentativeProfessionalStatus < ValueObject
  VALUES = [
    ENGLAND_OR_WALES_OR_NI_LEGAL_REP = new(:england_or_wales_or_ni_legal_rep),
    SCOTLAND_LEGAL_REP = new(:scotland_legal_rep),
    TAX_AGENT = new(:tax_agent),
    ACCOUNTANT = new(:accountant),
    FRIEND_OR_FAMILY = new(:friend_or_family),
    OTHER = new(:other)
  ]

  def self.values
    VALUES
  end
end
