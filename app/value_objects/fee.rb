class Fee < ValueObject
  def to_gbp
    GlimrFees.fee_amount(self) / 100.0
  end
end
