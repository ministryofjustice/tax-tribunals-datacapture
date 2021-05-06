class Language < ValueObject
  VALUES = [
    English = new(:english),
    EnglishWelsh = new(:english_welsh),
  ].freeze

  def self.values
    VALUES
  end
end
