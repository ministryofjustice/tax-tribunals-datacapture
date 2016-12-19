require 'spec_helper'

RSpec.describe CostDeterminer do
  let(:case_attrs)    { {} }
  let(:tribunal_case) {
    instance_double(TribunalCase,
      challenged_decision: challenged_decision,
      case_type:           case_type,
      dispute_type:        dispute_type,
      penalty_amount:      penalty_amount
    )
  }

  let(:challenged_decision) { nil }
  let(:case_type)           { nil }
  let(:dispute_type)        { nil }
  let(:penalty_amount)      { nil }

  subject { described_class.new(tribunal_case) }

  context "when there is no case_type" do
    it { is_expected.to fail_to_determine_lodgement_fee }
  end

  context "per default" do
    let(:case_type) { CaseType.new(:anything) }

    it { is_expected.to have_lodgement_fee(:fee_level_3) }
  end

  context "when there is a penalty and it is level 1" do
    let(:penalty_amount) { PenaltyAmount::PENALTY_LEVEL_1 }

    it { is_expected.to have_lodgement_fee(:fee_level_1) }
  end

  context "when there is a penalty and it is level 2" do
    let(:penalty_amount) { PenaltyAmount::PENALTY_LEVEL_2 }

    it { is_expected.to have_lodgement_fee(:fee_level_2) }
  end

  context "when there is a penalty and it is level 3" do
    let(:penalty_amount) { PenaltyAmount::PENALTY_LEVEL_3 }

    it { is_expected.to have_lodgement_fee(:fee_level_3) }
  end

  context "when there is a penalty but it is an unhandled value" do
    let(:penalty_amount) { PenaltyAmount.new('$^&%*') }

    it { is_expected.to fail_to_determine_lodgement_fee }
  end

  context "when the case is an appeal against a PAYE coding notice" do
    let(:dispute_type) { DisputeType::PAYE_CODING_NOTICE }

    it { is_expected.to have_lodgement_fee(:fee_level_2) }
  end

  context "when the case is an application for a decision on an enquiry" do
    let(:dispute_type) { DisputeType::DECISION_ON_ENQUIRY }

    it { is_expected.to have_lodgement_fee(:fee_level_2) }
  end
end
