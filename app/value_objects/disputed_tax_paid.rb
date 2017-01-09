class DisputedTaxPaid < ValueObject
  VALUES = [
    YES = new(:yes),
    NO  = new(:no)
  ]

  def self.values
    VALUES
  end
end
