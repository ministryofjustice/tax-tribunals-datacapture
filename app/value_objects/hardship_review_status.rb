class HardshipReviewStatus < ValueObject
  VALUES = [
    GRANTED = new(:granted),
    PENDING = new(:pending),
    REFUSED = new(:refused)
  ]

  def self.values
    VALUES
  end
end
