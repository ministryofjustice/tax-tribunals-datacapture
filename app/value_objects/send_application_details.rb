class SendApplicationDetails < ValueObject
  VALUES = [
    YES = new(:yes),
    NO  = new(:no),
  ].freeze

  def self.values
    VALUES
  end
end
