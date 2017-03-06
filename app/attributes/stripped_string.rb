class StrippedString < Virtus::Attribute
  def coerce(value)
    value.to_s.strip
  end
end
