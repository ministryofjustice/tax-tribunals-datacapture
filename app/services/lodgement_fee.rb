class LodgementFee < Fee
  FEE_LEVEL_1_VALUE =  20_00
  FEE_LEVEL_2_VALUE =  50_00
  FEE_LEVEL_3_VALUE = 200_00

  def self.fee_level_1
    new(FEE_LEVEL_1_VALUE)
  end

  def self.fee_level_2
    new(FEE_LEVEL_2_VALUE)
  end

  def self.fee_level_3
    new(FEE_LEVEL_3_VALUE)
  end
end
