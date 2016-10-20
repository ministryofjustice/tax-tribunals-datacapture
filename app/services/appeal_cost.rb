class AppealCost
  attr_reader :lodgement_fee

  # Lodgement fees in pence
  SMALL = 2000
  MEDIUM = 5000
  LARGE = 20000

  def self.small
    new(lodgement_fee: SMALL)
  end

  def self.medium
    new(lodgement_fee: MEDIUM)
  end

  def self.large
    new(lodgement_fee: LARGE)
  end

  def initialize(params)
    @lodgement_fee = params.fetch(:lodgement_fee)
  end
end
