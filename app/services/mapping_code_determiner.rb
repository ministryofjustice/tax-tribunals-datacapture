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
    # TODO: Replace with correct mapping codes once they have been agreed on
    case tribunal_case.penalty_level
    when PenaltyLevel::PENALTY_LEVEL_1
      MappingCode::TAXPENALTYLOW
    when PenaltyLevel::PENALTY_LEVEL_2
      MappingCode::TAXPENALTYMED
    when PenaltyLevel::PENALTY_LEVEL_3
      MappingCode::TAXPENALTYHIGH
    end
  end

  def dispute_type_mapping_code
    # TODO: Replace with correct mapping codes once they have been agreed on
    case tribunal_case.dispute_type
    when DisputeType::PAYE_CODING_NOTICE
      MappingCode::PAYECODING
    when DisputeType::INFORMATION_NOTICE
      MappingCode::TAXPENALTYMED
    when DisputeType::AMOUNT_OF_TAX,
         DisputeType::AMOUNT_AND_PENALTY,
         DisputeType::OTHER
      MappingCode::OTHERAPPLICATION
    end
  end

  def case_type_mapping_code
    # TODO: Replace with correct mapping codes once they have been agreed on
    case tribunal_case.case_type
    when CaseType::OTHER
      MappingCode::OTHERAPPEAL
    end
  end
end
