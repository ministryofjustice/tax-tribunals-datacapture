class LetterUploadType < ValueObject
  VALUES = [
    SINGLE    = new(:single),
    MULTIPLE  = new(:multiple),
    NO_LETTER = new(:no_letter)
  ].freeze

  def self.values
    VALUES
  end
end
