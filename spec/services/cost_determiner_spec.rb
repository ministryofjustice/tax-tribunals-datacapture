require 'rails_helper'

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
        let(:case_attrs) { super().merge(dispute_type: 'something') }

        specify { expect{ subject.lodgement_fee }.to raise_error("Unable to determine cost of VAT tribunal_case") }
      end

      context "when dispute is about late return/payment" do
        let(:case_attrs) { super().merge(dispute_type: 'late_return_or_payment') }

        context "when the penalty/surcharge amounts is £100" do
          let(:case_attrs) { super().merge(penalty_amount: '100_or_less') }

          it "has £20 lodgement fee" do
            expect(subject.lodgement_fee.value).to eq(2000)
          end
        end

        context "when the penalty/surcharge amounts is £200" do
          let(:case_attrs) { super().merge(penalty_amount: '101_to_20000') }

          it "has £50 lodgement fee" do
            expect(subject.lodgement_fee.value).to eq(5000)
          end
        end

        context "when the penalty/surcharge amounts is £20001" do
          let(:case_attrs) { super().merge(penalty_amount: '20001_or_more') }

          it "has £200 lodgement fee" do
            expect(subject.lodgement_fee.value).to eq(20000)
          end
        end
      end

      context "when dispute is about amount of tax owed" do
        let(:case_attrs) { super().merge(dispute_type: 'amount_of_tax_owed') }

        it "has £200 lodgement fee" do
          expect(subject.lodgement_fee.value).to eq(20000)
        end
      end
    end

    context "when tribunal_case is about advance payment notice penalty" do
      let(:case_attrs) { super().merge(case_type: CaseType::APN_PENALTY) }

      it "has £50 lodgement fee" do
        expect(subject.lodgement_fee.value).to eq(5000)
      end
    end

    context "when tribunal_case is about a closure notice" do
      let(:case_attrs) { super().merge(case_type: CaseType::CLOSURE_NOTICE) }

      it "has £50 lodgement fee" do
        expect(subject.lodgement_fee.value).to eq(5000)
      end
    end

    context "when tribunal_case is about an information notice" do
      let(:case_attrs) { super().merge(case_type: CaseType::INFORMATION_NOTICE) }

      it "has £50 lodgement fee" do
        expect(subject.lodgement_fee.value).to eq(5000)
      end
    end

    context "when tribunal_case is about request for review" do
      let(:case_attrs) { super().merge(case_type: CaseType::REQUEST_PERMISSION_FOR_REVIEW) }

      it "has £50 lodgement fee" do
        expect(subject.lodgement_fee.value).to eq(5000)
      end
    end

    context "when tribunal_case is about something else" do
      let(:case_attrs) { super().merge(case_type: CaseType::OTHER) }

      it "has £50 lodgement fee" do
        expect(subject.lodgement_fee.value).to eq(5000)
      end
    end

    context "when tribunal_case is about income tax" do
      let(:case_attrs) { super().merge(case_type: CaseType::INCOME_TAX) }

      context "when dispute is about an unhandled value" do
        let(:case_attrs) { super().merge(dispute_type: 'something') }

        specify { expect{ subject.lodgement_fee }.to raise_error("Unable to determine cost of income tax tribunal_case") }
      end

      context "when dispute is about amount of tax owed" do
        let(:case_attrs) { super().merge(dispute_type: 'amount_of_tax_owed') }

        it "has £200 lodgement fee" do
          expect(subject.lodgement_fee.value).to eq(20000)
        end
      end

      context "when dispute is about paye coding" do
        let(:case_attrs) { super().merge(dispute_type: 'paye_coding_notice') }

        it "has £50 lodgement fee" do
          expect(subject.lodgement_fee.value).to eq(5000)
        end
      end

      context "when dispute is about late return/payment" do
        let(:case_attrs) { super().merge(dispute_type: 'late_return_or_payment') }

        context "when the penalty/surcharge amounts is £100" do
          let(:case_attrs) { super().merge(penalty_amount: '100_or_less') }

          it "has £20 lodgement fee" do
            expect(subject.lodgement_fee.value).to eq(2000)
          end
        end

        context "when the penalty/surcharge amounts is £200" do
          let(:case_attrs) { super().merge(penalty_amount: '101_to_20000') }

          it "has £50 lodgement fee" do
            expect(subject.lodgement_fee.value).to eq(5000)
          end
        end

        context "when the penalty/surcharge amounts is £20001" do
          let(:case_attrs) { super().merge(penalty_amount: '20001_or_more') }

          it "has £200 lodgement fee" do
            expect(subject.lodgement_fee.value).to eq(20000)
          end
        end
      end
    end
  end
end
