require 'spec_helper'

shared_examples "any tax" do
  context "when dispute is about an unhandled value" do
    let(:dispute_type) { DisputeType.new('$^&%*') }

    it { is_expected.to fail_to_determine_lodgement_fee }
  end

  context "when dispute is about a penalty or surcharge" do
    let(:dispute_type) { DisputeType::PENALTY }

    context "and the penalty is level 1" do
      let(:penalty_amount) { PenaltyAmount::PENALTY_LEVEL_1 }

      it { is_expected.to have_lodgement_fee(:fee_level_1) }
    end

    context "and the penalty is level 2" do
      let(:penalty_amount) { PenaltyAmount::PENALTY_LEVEL_2 }

      it { is_expected.to have_lodgement_fee(:fee_level_2) }
    end

    context "and the penalty is level 3" do
      let(:penalty_amount) { PenaltyAmount::PENALTY_LEVEL_3 }

      it { is_expected.to have_lodgement_fee(:fee_level_3) }
    end

    context "when penalty amount is an unhandled value" do
      let(:penalty_amount) { PenaltyAmount.new('$^&%*') }

      it { is_expected.to fail_to_determine_lodgement_fee }
    end
  end

  context "when dispute is about amount of tax" do
    let(:dispute_type) { DisputeType::AMOUNT_OF_TAX }

    it { is_expected.to have_lodgement_fee(:fee_level_3) }
  end

  context "when dispute is about amount of tax and a penalty or surcharge" do
    let(:dispute_type) { DisputeType::AMOUNT_AND_PENALTY }

    it { is_expected.to have_lodgement_fee(:fee_level_3) }
  end

  context "when dispute is about applying for a decision on an inquiry" do
    let(:dispute_type) { DisputeType::DECISION_ON_ENQUIRY }

    it { is_expected.to have_lodgement_fee(:fee_level_2) }
  end

  context "when dispute is about something else" do
    let(:dispute_type) { DisputeType::OTHER }

    it { is_expected.to have_lodgement_fee(:fee_level_3) }
  end
end

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

  context "when tribunal_case#case_type is nil" do
    let(:case_type) { nil }

    it { is_expected.to fail_to_determine_lodgement_fee }
  end

  context "when tribunal_case is about an unhandled value" do
    let(:case_type) { CaseType.new('^&@*$@') }

    it { is_expected.to fail_to_determine_lodgement_fee }
  end

  context "when tribunal_case is about income tax" do
    let(:case_type) { CaseType::INCOME_TAX }

    it_behaves_like "any tax"

    context "when dispute is about PAYE coding notice" do
      let(:dispute_type) { DisputeType::PAYE_CODING_NOTICE }

      it { is_expected.to have_lodgement_fee(:fee_level_2) }
    end
  end

  context "when tribunal_case is about VAT" do
    let(:case_type) { CaseType::VAT }

    it_behaves_like "any tax"
  end

  context "when tribunal_case is about advance payment notice penalty" do
    let(:case_type) { CaseType::APN_PENALTY }

    it { is_expected.to have_lodgement_fee(:fee_level_2) }
  end

  context "when tribunal_case is about a closure notice" do
    let(:case_type) { CaseType::CLOSURE_NOTICE }

    it { is_expected.to have_lodgement_fee(:fee_level_2) }
  end

  context "when tribunal_case is about an information notice" do
    let(:case_type) { CaseType::INFORMATION_NOTICE }

    it { is_expected.to have_lodgement_fee(:fee_level_2) }
  end

  context "when tribunal_case is about request for review" do
    let(:case_type) { CaseType::REQUEST_PERMISSION_FOR_REVIEW }

    it { is_expected.to have_lodgement_fee(:fee_level_2) }
  end

  context "when tribunal_case is about something else" do
    let(:case_type) { CaseType::OTHER }

    it { is_expected.to have_lodgement_fee(:fee_level_2) }
  end
end
