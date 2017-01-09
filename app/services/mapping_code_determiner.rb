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
    if tribunal_case.penalty_amount
      penalty_mapping_code
    elsif tribunal_case.dispute_type
      dispute_type_mapping_code
    elsif tribunal_case.case_type
      case_type_mapping_code
    end
  end

  def penalty_mapping_code
    case tribunal_case.penalty_amount
    when PenaltyAmount::PENALTY_LEVEL_1
      MappingCode::APPL_PENALTY_LOW
    when PenaltyAmount::PENALTY_LEVEL_2
      MappingCode::APPL_PENALTY_MED
    when PenaltyAmount::PENALTY_LEVEL_3
      MappingCode::APPL_PENALTY_HIGH
    end
  end

  def dispute_type_mapping_code
    case tribunal_case.dispute_type
    when DisputeType::DECISION_ON_ENQUIRY
      MappingCode::APPN_CLOSEENQUIRY
    when DisputeType::PAYE_CODING_NOTICE
      MappingCode::APPL_PAYECODING
    when DisputeType::INFORMATION_NOTICE
      MappingCode::APPL_INFONOTICE
    when DisputeType::AMOUNT_OF_TAX,
         DisputeType::AMOUNT_AND_PENALTY,
         DisputeType::OTHER
      MappingCode::APPL_OTHER
    end
  end

  def case_type_mapping_code
    case tribunal_case.case_type
    when CaseType::OTHER
      MappingCode::APPL_OTHER
    end
  end
end
