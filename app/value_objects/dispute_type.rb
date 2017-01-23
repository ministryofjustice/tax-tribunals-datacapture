class DisputeType < ValueObject
  VALUES = [
    PENALTY             = new(:penalty),
    AMOUNT_OF_TAX       = new(:amount_of_tax),
    AMOUNT_AND_PENALTY  = new(:amount_and_penalty),
    PAYE_CODING_NOTICE  = new(:paye_coding_notice),
    INFORMATION_NOTICE  = new(:information_notice),
    OTHER               = new(:other)
  ].freeze

  def self.values
    VALUES
  end

  def ask_penalty?
    self == PENALTY
  end

  def ask_tax?
    self == AMOUNT_OF_TAX
  end

  def ask_penalty_and_tax?
    self == AMOUNT_AND_PENALTY
  end

  def ask_hardship?
    [AMOUNT_OF_TAX, AMOUNT_AND_PENALTY].include?(self)
  end
end
