class LetterUploadType < ValueObject
  VALUES = [
    SINGLE   = new(:single),
    MULTIPLE = new(:multiple)
  ].freeze

  def self.values
    VALUES
  end
end
