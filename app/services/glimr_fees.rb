class GlimrFees
  # TODO: These should actually be fetched from GLiMR periodically.
  #   Hardcoded here until we have fully functional API access.
  def self.lodgement_fee_amount(tribunal_case)
    case tribunal_case.mapping_code
    when MappingCode::TAXPENALTYLOW
      20_00
    when MappingCode::TAXPENALTYMED,
         MappingCode::PAYECODING,
         MappingCode::APPNTOCLOSE
      50_00
    when MappingCode::TAXPENALTYHIGH,
         MappingCode::OTHERAPPEAL,
         MappingCode::OTHERAPPLICATION
      200_00
    else
      raise ArgumentError, 'Unknown mapping code'
    end
  end
end
