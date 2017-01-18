class MappingCodeDeterminer
  attr_reader :tribunal_case

  def initialize(tribunal_case)
    @tribunal_case = tribunal_case
  end

  def valid_for_determining_mapping_code?
    mapping_code_or_nil.present?
  end

  def mapping_code
    raise 'Unable to determine mapping code for tribunal_case' unless mapping_code_or_nil
    mapping_code_or_nil
  end

  private

  def mapping_code_or_nil
    if tribunal_case.penalty_level
      penalty_mapping_code
    elsif tribunal_case.dispute_type
      dispute_type_mapping_code
    elsif tribunal_case.case_type
      case_type_mapping_code
    end
  end

  def penalty_mapping_code
    case tribunal_case.penalty_level
    when PenaltyLevel::PENALTY_LEVEL_1
      MappingCode::APPEAL_PENALTY_LOW
    when PenaltyLevel::PENALTY_LEVEL_2
      MappingCode::APPEAL_PENALTY_MED
    when PenaltyLevel::PENALTY_LEVEL_3
      MappingCode::APPEAL_PENALTY_HIGH
    end
  end

  def dispute_type_mapping_code
    case tribunal_case.dispute_type
    when DisputeType::DECISION_ON_ENQUIRY
      MappingCode::APPN_DECISION_ENQRY
    when DisputeType::PAYE_CODING_NOTICE
      MappingCode::APPEAL_PAYECODING
    when DisputeType::INFORMATION_NOTICE
      MappingCode::APPEAL_INFONOTICE
    when DisputeType::AMOUNT_OF_TAX,
         DisputeType::AMOUNT_AND_PENALTY,
         DisputeType::OTHER
      MappingCode::APPEAL_OTHER
    end
  end

  def case_type_mapping_code
    # TODO: Add further when-branches once we have additional case types
    case tribunal_case.case_type
    when CaseType::OTHER
      MappingCode::APPEAL_OTHER
    end
  end
end
