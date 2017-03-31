module MappingCodeDeterminer
  def valid_for_determining_mapping_code?
    mapping_code_or_nil.present?
  end

  def mapping_code
    raise 'Unable to determine mapping code for tribunal_case' unless mapping_code_or_nil
    mapping_code_or_nil
  end

  private

  def mapping_code_or_nil
    if penalty_level
      penalty_mapping_code
    elsif dispute_type
      dispute_type_mapping_code
    elsif closure_case_type
      closure_case_type_mapping_code
    elsif case_type
      case_type_mapping_code
    end
  end

  def penalty_mapping_code
    case penalty_level
    when PenaltyLevel::PENALTY_LEVEL_1
      MappingCode::APPEAL_PENALTY_LOW
    when PenaltyLevel::PENALTY_LEVEL_2
      MappingCode::APPEAL_PENALTY_MED
    when PenaltyLevel::PENALTY_LEVEL_3
      MappingCode::APPEAL_PENALTY_HIGH
    end
  end

  def dispute_type_mapping_code
    case dispute_type
    when DisputeType::PAYE_CODING_NOTICE
      MappingCode::APPEAL_PAYECODING
    when DisputeType::INFORMATION_NOTICE
      MappingCode::APPEAL_INFONOTICE
    when DisputeType::AMOUNT_OF_TAX_OWED_BY_HMRC,
         DisputeType::AMOUNT_OF_TAX_OWED_BY_TAXPAYER,
         DisputeType::AMOUNT_AND_PENALTY,
         DisputeType::OTHER
      MappingCode::APPEAL_OTHER
    end
  end

  def case_type_mapping_code
    # TODO: Add further when-branches once we have additional case types
    case case_type
    when CaseType::COUNTERACTION_NOTICE
      MappingCode::APPN_DECISION_ENQRY
    when CaseType::REQUEST_LATE_REVIEW
      MappingCode::APPN_LATE
    when CaseType::OTHER
      MappingCode::APPEAL_OTHER
    else
      MappingCode::APPN_OTHER
    end
  end

  def closure_case_type_mapping_code
    MappingCode::APPN_DECISION_ENQRY
  end
end
