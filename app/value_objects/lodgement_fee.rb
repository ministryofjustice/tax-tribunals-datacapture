class LodgementFee < Fee
  VALUES = [
    FEE_LEVEL_1 = new(:fee_level_1),
    FEE_LEVEL_2 = new(:fee_level_2),
    FEE_LEVEL_3 = new(:fee_level_3)
  ].freeze
end
