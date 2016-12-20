class InTime < ValueObject
  VALUES = [
    YES    = new(:yes),
    NO     = new(:no),
    UNSURE = new(:unsure)
  ].freeze

  def self.values
    VALUES
  end
end
