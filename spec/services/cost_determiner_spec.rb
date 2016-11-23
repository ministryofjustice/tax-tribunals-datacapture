require 'spec_helper'

RSpec.describe CostDeterminer do
  let(:case_attrs)    { {} }
  let(:tribunal_case) { instance_double(TribunalCase, case_attrs) }

  subject { described_class.new(tribunal_case) }

  context "when tribunal_case#case_type is nil" do
    let(:case_attrs) { super().merge(case_type: nil) }

    specify { expect{ subject.lodgement_fee }.to raise_error("Unable to determine cost of tribunal_case") }
  end

  context "when tribunal_case is about an unhandled value" do
    let(:case_attrs) { super().merge(case_type: CaseType.new('^&@*$@')) }

    specify { expect{ subject.lodgement_fee }.to raise_error("Unable to determine cost of tribunal_case") }
  end

  context "when hmrc challenged is true" do
    let(:case_attrs) { super().merge(challenged_decision: true) }

    context "when tribunal_case is about VAT" do
      let(:case_attrs) { super().merge(case_type: CaseType::VAT) }

      context "when dispute is about an unhandled value" do
        let(:case_attrs) { super().merge(dispute_type: DisputeType.new('$^&%*')) }

        specify { expect{ subject.lodgement_fee }.to raise_error("Unable to determine cost of VAT tribunal_case") }
      end

      context "when dispute is about late return/payment" do
        let(:case_attrs) { super().merge(dispute_type: DisputeType::LATE_RETURN_OR_PAYMENT) }

        context "when dispute is about an unhandled fee level" do
          let(:case_attrs) { super().merge(penalty_amount: PenaltyAmount.new('ALL THE MONEYS')) }

          specify { expect{ subject.lodgement_fee }.to raise_error("Unable to determine cost of penalty tribunal_case") }
        end

        context "when the penalty/surcharge amounts is £100" do
          let(:case_attrs) { super().merge(penalty_amount: PenaltyAmount::PENALTY_LEVEL_1) }

          it "has £20 lodgement fee" do
            expect(subject.lodgement_fee).to eq(LodgementFee::FEE_LEVEL_1)
          end
        end

        context "when the penalty/surcharge amounts is £200" do
          let(:case_attrs) { super().merge(penalty_amount: PenaltyAmount::PENALTY_LEVEL_2) }

          it "has £50 lodgement fee" do
            expect(subject.lodgement_fee).to eq(LodgementFee::FEE_LEVEL_2)
          end
        end

        context "when the penalty/surcharge amounts is £20001" do
          let(:case_attrs) { super().merge(penalty_amount: PenaltyAmount::PENALTY_LEVEL_3) }

          it "has £200 lodgement fee" do
            expect(subject.lodgement_fee).to eq(LodgementFee::FEE_LEVEL_3)
          end
        end
      end

      context "when dispute is about amount of tax owed" do
        let(:case_attrs) { super().merge(dispute_type: DisputeType::AMOUNT_OF_TAX_OWED) }

        it "has £200 lodgement fee" do
          expect(subject.lodgement_fee).to eq(LodgementFee::FEE_LEVEL_3)
        end
      end
    end

    context "when tribunal_case is about advance payment notice penalty" do
      let(:case_attrs) { super().merge(case_type: CaseType::APN_PENALTY) }

      it "has £50 lodgement fee" do
        expect(subject.lodgement_fee).to eq(LodgementFee::FEE_LEVEL_2)
      end
    end

    context "when tribunal_case is about a closure notice" do
      let(:case_attrs) { super().merge(case_type: CaseType::CLOSURE_NOTICE) }

      it "has £50 lodgement fee" do
        expect(subject.lodgement_fee).to eq(LodgementFee::FEE_LEVEL_2)
      end
    end

    context "when tribunal_case is about an information notice" do
      let(:case_attrs) { super().merge(case_type: CaseType::INFORMATION_NOTICE) }

      it "has £50 lodgement fee" do
        expect(subject.lodgement_fee).to eq(LodgementFee::FEE_LEVEL_2)
      end
    end

    context "when tribunal_case is about request for review" do
      let(:case_attrs) { super().merge(case_type: CaseType::REQUEST_PERMISSION_FOR_REVIEW) }

      it "has £50 lodgement fee" do
        expect(subject.lodgement_fee).to eq(LodgementFee::FEE_LEVEL_2)
      end
    end

    context "when tribunal_case is about something else" do
      let(:case_attrs) { super().merge(case_type: CaseType::OTHER) }

      it "has £50 lodgement fee" do
        expect(subject.lodgement_fee).to eq(LodgementFee::FEE_LEVEL_2)
      end
    end

    context "when tribunal_case is about income tax" do
      let(:case_attrs) { super().merge(case_type: CaseType::INCOME_TAX) }

      context "when dispute is about an unhandled value" do
        let(:case_attrs) { super().merge(dispute_type: DisputeType.new('%$^&*@')) }

        specify { expect{ subject.lodgement_fee }.to raise_error("Unable to determine cost of income tax tribunal_case") }
      end

      context "when dispute is about amount of tax owed" do
        let(:case_attrs) { super().merge(dispute_type: DisputeType::AMOUNT_OF_TAX_OWED) }

        it "has £200 lodgement fee" do
          expect(subject.lodgement_fee).to eq(LodgementFee::FEE_LEVEL_3)
        end
      end

      context "when dispute is about paye coding" do
        let(:case_attrs) { super().merge(dispute_type: DisputeType::PAYE_CODING_NOTICE) }

        it "has £50 lodgement fee" do
          expect(subject.lodgement_fee).to eq(LodgementFee::FEE_LEVEL_2)
        end
      end

      context "when dispute is about late return/payment" do
        let(:case_attrs) { super().merge(dispute_type: DisputeType::LATE_RETURN_OR_PAYMENT) }

        context "when dispute is about an unhandled fee level" do
          let(:case_attrs) { super().merge(penalty_amount: PenaltyAmount.new('ALL THE MONEYS')) }

          specify { expect{ subject.lodgement_fee }.to raise_error("Unable to determine cost of penalty tribunal_case") }
        end

        context "when the penalty/surcharge amounts is £100" do
          let(:case_attrs) { super().merge(penalty_amount: PenaltyAmount::PENALTY_LEVEL_1) }

          it "has £20 lodgement fee" do
            expect(subject.lodgement_fee).to eq(LodgementFee::FEE_LEVEL_1)
          end
        end

        context "when the penalty/surcharge amounts is £200" do
          let(:case_attrs) { super().merge(penalty_amount: PenaltyAmount::PENALTY_LEVEL_2) }

          it "has £50 lodgement fee" do
            expect(subject.lodgement_fee).to eq(LodgementFee::FEE_LEVEL_2)
          end
        end

        context "when the penalty/surcharge amounts is £20001" do
          let(:case_attrs) { super().merge(penalty_amount: PenaltyAmount::PENALTY_LEVEL_3) }

          it "has £200 lodgement fee" do
            expect(subject.lodgement_fee).to eq(LodgementFee::FEE_LEVEL_3)
          end
        end
      end
    end
  end
end
