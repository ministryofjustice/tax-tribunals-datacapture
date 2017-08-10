require 'rails_helper'

RSpec.describe LetterTypeHelper do
  describe '#i18n_letter_type' do
    let(:tribunal_case) { instance_double(TribunalCase) }

    before do
      allow(tribunal_case).to receive(:challenged_decision_status).and_return(decision_status)
      allow(helper).to receive(:current_tribunal_case).and_return(tribunal_case)
    end

    context 'for a challenge decision status of `received`' do
      let(:decision_status) {ChallengedDecisionStatus::RECEIVED}
      it {expect(helper.i18n_letter_type).to eq(:review_conclusion_letter)}
    end

    context 'for a challenge decision status of `late appeal`' do
      let(:decision_status) {ChallengedDecisionStatus::APPEAL_LATE_REJECTION}
      it {expect(helper.i18n_letter_type).to eq(:late_appeal_refusal_letter)}
    end

    context 'for a challenge decision status of `late review`' do
      let(:decision_status) {ChallengedDecisionStatus::REVIEW_LATE_REJECTION}
      it {expect(helper.i18n_letter_type).to eq(:late_review_refusal_letter)}
    end

    context 'for a challenge decision status of `appealing directly`' do
      let(:decision_status) {ChallengedDecisionStatus::APPEALING_DIRECTLY}
      it {expect(helper.i18n_letter_type).to eq(:original_notice_letter)}
    end

    context 'for a challenge decision status of `overdue`' do
      let(:decision_status) {ChallengedDecisionStatus::OVERDUE}
      it {expect(helper.i18n_letter_type).to eq(:original_notice_letter)}
    end

    context 'for a challenge decision status of `refused`' do
      let(:decision_status) {ChallengedDecisionStatus::REFUSED}
      it {expect(helper.i18n_letter_type).to eq(:original_notice_letter)}
    end
  end
end
