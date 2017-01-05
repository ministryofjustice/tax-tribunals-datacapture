class GlimrFees
  # TODO: These should actually be fetched from GLiMR periodically.
  #   Hardcoded here until we have fully functional API access.
  def self.lodgement_fee_amount(tribunal_case)
    case tribunal_case.mapping_code
    when MappingCode::APPL_PENALTY_LOW
      20_00
    when MappingCode::APPL_PENALTY_MED
      50_00
    when MappingCode::APPL_PENALTY_HIGH
      200_00
    when MappingCode::APPL_PAYECODING
      50_00
    when MappingCode::APPL_INFONOTICE
      50_00
    when MappingCode::APPL_OTHER
      200_00
    when MappingCode::APPN_CLOSEENQUIRY
      50_00
    when MappingCode::APPN_OTHER
      200_00
    else
      raise ArgumentError, 'Unknown mapping code'
    end
  end
end
