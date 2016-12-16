class DisputeType < ValueObject
  VALUES = [
    PAYE_CODING_NOTICE  = new(:paye_coding_notice),
    PENALTY             = new(:penalty),
    AMOUNT_OF_TAX       = new(:amount_of_tax),
    AMOUNT_AND_PENALTY  = new(:amount_and_penalty),
    DECISION_ON_ENQUIRY = new(:decision_on_enquiry),
    OTHER               = new(:other)
  ].freeze

  def self.values
    VALUES
  end

  def initialize(raw_value)
    raise ArgumentError.new('Dispute type must be symbol or implicitly convertible') unless raw_value.respond_to?(:to_sym)
    super(raw_value.to_sym)
  end
end
