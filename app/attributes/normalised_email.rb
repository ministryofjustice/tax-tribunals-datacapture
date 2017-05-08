class NormalisedEmail < Virtus::Attribute
  def coerce(value)
    NormalisedEmailType.new.cast(value)
  end
end
