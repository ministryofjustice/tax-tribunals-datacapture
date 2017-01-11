class GlimrFees
  # TODO: These should actually be fetched from GLiMR periodically.
  #   Hardcoded here until we have fully functional API access.
  def self.lodgement_fee_amount(tribunal_case)
    case tribunal_case.mapping_code
    when MappingCode::APPEAL_PENALTY_LOW
      20_00
    when MappingCode::APPEAL_PENALTY_MED,
         MappingCode::APPEAL_PAYECODING,
         MappingCode::APPEAL_INFONOTICE,
         MappingCode::APPN_DECISION_ENQRY,
         MappingCode::APPN_LATE
      50_00
    when MappingCode::APPEAL_PENALTY_HIGH,
         MappingCode::APPEAL_OTHER,
         MappingCode::APPN_OTHER
      200_00
    else
      raise ArgumentError, 'Unknown mapping code'
    end
  end
end
