class DisputeType < ValueObject
  VALUES = [
    PENALTY             = new(:penalty),
    AMOUNT_OF_TAX       = new(:amount_of_tax),
    AMOUNT_OF_TAX_OWED  = new(:amount_of_tax_owed),
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
    [AMOUNT_OF_TAX, AMOUNT_OF_TAX_OWED].include?(self)
  end

  def ask_penalty_and_tax?
    self == AMOUNT_AND_PENALTY
  end

  def ask_hardship?
    ask_tax? || ask_penalty_and_tax?
  end
end
