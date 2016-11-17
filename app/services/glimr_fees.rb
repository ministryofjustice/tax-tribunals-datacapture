class GlimrFees
  def self.fee_amount(fee)
    case fee
    when LodgementFee::FEE_LEVEL_1
      20_00
    when LodgementFee::FEE_LEVEL_2
      50_00
    when LodgementFee::FEE_LEVEL_3
      200_00
    else
      raise ArgumentError, 'Fee must be a known Fee value'
    end
  end
end
