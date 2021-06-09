class DisputeType < ValueObject
  VALUES = [
    PENALTY                        = new(:penalty),
    AMOUNT_OF_TAX_OWED_BY_HMRC     = new(:amount_of_tax_owed_by_hmrc),
    AMOUNT_OF_TAX_OWED_BY_TAXPAYER = new(:amount_of_tax_owed_by_taxpayer),
    AMOUNT_AND_PENALTY             = new(:amount_and_penalty),
    PAYE_CODING_NOTICE             = new(:paye_coding_notice),
    INFORMATION_NOTICE             = new(:information_notice),
    REFUSAL_TO_REGISTER_APPLICANT  = new(:refusal_to_register_applicant),
    CANCELLATION_OF_REGISTRATION   = new(:cancellation_of_registration),
    SECURITY_NOTICE                = new(:security_notice),
    REGISTRATION                   = new(:registration),
    OTHER                          = new(:other)
  ].freeze

  def self.values
    VALUES
  end

  def ask_penalty?
    self == PENALTY
  end

  def ask_penalty_and_tax?
    self == AMOUNT_AND_PENALTY
  end

  def ask_tax?
    [AMOUNT_OF_TAX_OWED_BY_HMRC, AMOUNT_OF_TAX_OWED_BY_TAXPAYER].include?(self)
  end

  def ask_hardship?
    [AMOUNT_OF_TAX_OWED_BY_TAXPAYER, AMOUNT_AND_PENALTY].include?(self)
  end
end
