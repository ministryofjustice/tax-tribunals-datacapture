class ContactableEntityType < ValueObject
  VALUES = [
    INDIVIDUAL         = new(:individual),
    COMPANY            = new(:company),
    OTHER_ORGANISATION = new(:other_organisation)
  ].freeze

  def self.values
    VALUES
  end
end
