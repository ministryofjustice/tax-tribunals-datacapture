require 'spec_helper'

RSpec.describe MappingCodeDeterminer do
  let(:case_attrs)    { {} }
  let(:tribunal_case) {
    instance_double(TribunalCase,
      challenged_decision: challenged_decision,
      case_type:           case_type,
      dispute_type:        dispute_type,
      penalty_level:       penalty_level
    )
  }

  let(:challenged_decision) { nil }
  let(:case_type)           { nil }
  let(:dispute_type)        { nil }
  let(:penalty_level)       { nil }

  subject { described_class.new(tribunal_case) }

  context 'when there is no case_type' do
    it { is_expected.to fail_to_determine_mapping_code }
  end

  context 'when there is a penalty and it is level 1' do
    let(:penalty_level) { PenaltyLevel::PENALTY_LEVEL_1 }

    it { is_expected.to have_mapping_code(:taxpenaltylow) }
  end

  context 'when there is a penalty and it is level 2' do
    let(:penalty_level) { PenaltyLevel::PENALTY_LEVEL_2 }

    it { is_expected.to have_mapping_code(:taxpenaltymed) }
  end

  context 'when there is a penalty and it is level 3' do
    let(:penalty_level) { PenaltyLevel::PENALTY_LEVEL_3 }

    it { is_expected.to have_mapping_code(:taxpenaltyhigh) }
  end

  context 'when there is a penalty but it is an unhandled value' do
    let(:penalty_level) { PenaltyLevel.new('$^&%*') }

    it { is_expected.to fail_to_determine_mapping_code }
  end

  context 'when the dispute is an appeal against a PAYE coding notice' do
    let(:dispute_type) { DisputeType::PAYE_CODING_NOTICE }

    it { is_expected.to have_mapping_code(:payecoding) }
  end

  context 'when the dispute is an appeal against an information notice' do
    let(:dispute_type) { DisputeType::INFORMATION_NOTICE }

    it { is_expected.to have_mapping_code(:taxpenaltymed) }
  end

  context 'when the dispute is about amount of tax' do
    let(:dispute_type) { DisputeType::AMOUNT_OF_TAX }

    it { is_expected.to have_mapping_code(:otherapplication) }
  end

  context 'when the dispute is about amount of tax and a penalty' do
    let(:dispute_type) { DisputeType::AMOUNT_AND_PENALTY }

    it { is_expected.to have_mapping_code(:otherapplication) }
  end

  context 'when the dispute is about something else' do
    let(:dispute_type) { DisputeType::OTHER }

    it { is_expected.to have_mapping_code(:otherapplication) }
  end

  context 'when the dispute is about penalty but there is no penalty amount' do
    let(:dispute_type) { DisputeType::PENALTY }

    it { is_expected.to fail_to_determine_mapping_code }
  end

  context 'when there is a dispute type but it is an unhandled value' do
    let(:dispute_type) { DisputeType.new(:anything_else) }

    it { is_expected.to fail_to_determine_mapping_code }
  end

  context 'when the case type is about something else' do
    let(:case_type) { CaseType::OTHER }

    it { is_expected.to have_mapping_code(:otherappeal) }
  end

  context 'when there is a case type but it is an unhandled value' do
    let(:case_type) { CaseType.new(:anything_else) }

    it { is_expected.to fail_to_determine_mapping_code }
  end
end
