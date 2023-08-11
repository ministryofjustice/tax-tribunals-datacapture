class SendApplicationDetails < ValueObject
  VALUES = [
    EMAIL = new(:email),
    TEXT  = new(:text),
    BOTH  = new(:both),
    NONE  = new(:none),
  ].freeze

  def self.values
    VALUES
  end
end
