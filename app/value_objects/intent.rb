class Intent < ValueObject
  VALUES = [
    TAX_APPEAL    = new(:tax_appeal),
    CLOSE_ENQUIRY = new(:close_enquiry)
  ].freeze

  def self.values
    VALUES
  end
end
