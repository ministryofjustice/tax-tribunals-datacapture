require 'rails_helper'

RSpec.describe CostDeterminer do
  let(:appeal_attrs) { { valid?: true } }
  let(:appeal) { double(appeal_attrs) }

  subject { described_class.new(appeal) }

  context "when appeal is invalid" do
    let(:appeal_attrs) { super().merge(valid?: false) }

    it "raises bad appeal error" do
      expect{ subject.run }.to raise_error(InvalidAppealError)
    end
  end

  context "when hmrc challenged is true" do
    let(:appeal_attrs) { super().merge(hmrc_challenged: true) }

    context "when appeal is about advance payment notice penalty" do
      let(:appeal_attrs) { super().merge(appeal_about: :apn_penalty) }

      it "has £50 lodgement fee" do
        expect(subject.run.lodgement_fee).to eq(5000)
      end
    end

    context "when appeal is about a closure notice" do
      let(:appeal_attrs) { super().merge(appeal_about: :closure_notice) }

      it "has £50 lodgement fee" do
        expect(subject.run.lodgement_fee).to eq(5000)
      end
    end

    context "when appeal is about an information notice" do
      let(:appeal_attrs) { super().merge(appeal_about: :information_notice) }

      it "has £50 lodgement fee" do
        expect(subject.run.lodgement_fee).to eq(5000)
      end
    end

    context "when appeal is about request for review" do
      let(:appeal_attrs) { super().merge(appeal_about: :request_permission_for_review) }

      it "has £50 lodgement fee" do
        expect(subject.run.lodgement_fee).to eq(5000)
      end
    end

    context "when appeal is about something else" do
      let(:appeal_attrs) { super().merge(appeal_about: :other) }

      it "has £50 lodgement fee" do
        expect(subject.run.lodgement_fee).to eq(5000)
      end
    end

    context "when appeal is about income tax" do
      let(:appeal_attrs) { super().merge(appeal_about: :income_tax) }

      context "when dispute is about amount of tax owed" do
        let(:appeal_attrs) { super().merge(dispute_about: :amount_of_tax_owed) }

        it "has £200 lodgement fee" do
          expect(subject.run.lodgement_fee).to eq(20000)
        end
      end

      context "when dispute is about paye coding" do
        let(:appeal_attrs) { super().merge(dispute_about: :paye_coding_notice) }

        it "has £50 lodgement fee" do
          expect(subject.run.lodgement_fee).to eq(5000)
        end
      end
    end
  end
end
