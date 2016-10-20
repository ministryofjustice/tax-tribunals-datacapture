class AppealCost
  attr_reader :lodgement_fee

  def initialize(params)
    @lodgement_fee = params.fetch(:lodgement_fee)
  end
end
