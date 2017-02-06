class UserType < ValueObject
  VALUES = [
    TAXPAYER       = new(:taxpayer),
    REPRESENTATIVE = new(:representative)
  ].freeze

  def self.values
    VALUES
  end
end
