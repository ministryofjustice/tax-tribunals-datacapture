require 'spec_helper'

RSpec.describe AppealTypeAnswersPresenter do
  subject { described_class.new(tribunal_case) }

  let(:tribunal_case) {
    instance_double(
      TribunalCase,
      challenged_decision: challenged_decision,
      challenged_decision_status: challenged_decision_status,
      case_type: case_type,
      case_type_other_value: case_type_other_value,
      dispute_type: dispute_type,
      dispute_type_other_value: dispute_type_other_value,
      penalty_level: penalty_level,
      penalty_amount: penalty_amount,
      tax_amount: tax_amount,
      disputed_tax_paid: disputed_tax_paid,
      hardship_review_requested: hardship_review_requested,
      hardship_review_status: hardship_review_status
    )
  }

  let(:paths) { Rails.application.routes.url_helpers }

  let(:challenged_decision)        { nil }
  let(:challenged_decision_status) { nil }
  let(:case_type)                  { nil }
  let(:case_type_other_value)      { nil }
  let(:dispute_type)               { nil }
  let(:dispute_type_other_value)   { nil }
  let(:penalty_level)              { nil }
  let(:penalty_amount)             { nil }
  let(:tax_amount)                 { nil }
  let(:disputed_tax_paid)          { nil }
  let(:hardship_review_requested)  { nil }
  let(:hardship_review_status)     { nil }

  let(:declared_rows) {
    [
        :case_type_question,
        :challenged_decision_question,
        :challenged_decision_status_question,
        :dispute_type_question,
        :penalty_level_question,
        :penalty_amount_question,
        :tax_amount_question,
        :disputed_tax_paid_question,
        :hardship_review_requested_question,
        :hardship_review_status_question
    ].freeze
  }

  describe '#rows' do
    before do
      declared_rows.each do |row_method|
        expect(subject).to receive(row_method).and_return(row_method)
      end
    end

    it 'should have the correct order' do
      expect(subject.rows).to eq(declared_rows)
    end
  end

  describe '`challenged_decision` question' do
    let(:row) { subject.challenged_decision_question }
    let(:challenged_decision) { true }

    context 'when appeal is challenged' do
      it 'has the correct attributes' do
        expect(row.question).to    eq('.questions.challenged_decision')
        expect(row.answer).to      eq('.answers.challenged_decision.true')
        expect(row.change_path).to be_nil
      end
    end

    context 'when appeal is unchallenged' do
      let(:challenged_decision) { false }

      it 'has the correct attributes' do
        expect(row.question).to    eq('.questions.challenged_decision')
        expect(row.answer).to      eq('.answers.challenged_decision.false')
        expect(row.change_path).to be_nil
      end
    end
  end

  describe '`challenged_decision_status` question' do
    let(:row) { subject.challenged_decision_status_question }

    context 'when appeal is challenged' do
      context 'for a received status' do
        let(:challenged_decision_status) { ChallengedDecisionStatus::RECEIVED }

        it 'has the correct attributes' do
          expect(row.question).to    eq('.questions.challenged_decision_status')
          expect(row.answer).to      eq('.answers.challenged_decision_status.received')
          expect(row.change_path).to be_nil
        end
      end

      context 'for a overdue status' do
        let(:challenged_decision_status) { ChallengedDecisionStatus::OVERDUE }

        it 'has the correct attributes' do
          expect(row.question).to    eq('.questions.challenged_decision_status')
          expect(row.answer).to      eq('.answers.challenged_decision_status.overdue')
          expect(row.change_path).to be_nil
        end
      end
    end
  end

  describe '`case_type` question' do
    let(:row) { subject.case_type_question }

    context 'for a specific case type' do
      let(:case_type) { 'foo' }

      it 'has the correct attributes' do
        expect(row.question).to    eq('.questions.case_type')
        expect(row.answer).to      eq('.answers.case_type.foo')
        expect(row.change_path).to eq(paths.edit_steps_appeal_case_type_path)
      end

      it 'has a change link' do
        expect(row.change_link('test')).to eq('<a href="/steps/appeal/case_type">test</a>')
      end
    end

    context 'for `other` case type' do
      let(:case_type) { CaseType::OTHER }
      let(:case_type_other_value) { 'my tax issue' }

      it 'has the correct attributes' do
        expect(row.question).to    eq('.questions.case_type')
        expect(row.answer).to      eq('my tax issue')
        expect(row.change_path).to eq(paths.edit_steps_appeal_case_type_path)
      end

      it 'has a change link' do
        expect(row.change_link('test')).to eq('<a href="/steps/appeal/case_type">test</a>')
      end
    end
  end

  describe '`dispute_type` question' do
    let(:row) { subject.dispute_type_question }
    let(:case_type) { 'income_tax' }

    context 'when `dispute_type` is nil' do
      let(:dispute_type) { nil }

      it 'is not included' do
        expect(row).to be_nil
      end
    end

    context 'for a specific dispute type' do
      let(:dispute_type) { 'foo' }

      it 'has the correct attributes' do
        expect(row.question).to    eq('.questions.dispute_type')
        expect(row.answer).to      eq('.answers.dispute_type.foo')
        expect(row.change_path).to be_nil
      end
    end

    context 'for `other` dispute type' do
      let(:dispute_type) { DisputeType::OTHER }
      let(:dispute_type_other_value) { 'my dispute' }

      it 'has the correct attributes' do
        expect(row.question).to    eq('.questions.dispute_type')
        expect(row.answer).to      eq('my dispute')
        expect(row.change_path).to be_nil
      end
    end
  end

  describe '`penalty_level` question' do
    let(:row) { subject.penalty_level_question }

    context 'when `penalty_level` is nil' do
      let(:penalty_level) { nil }

      it 'is not included' do
        expect(row).to be_nil
      end
    end

    context 'when `penalty_level` is given' do
      let(:penalty_level) { 'foo' }

      it 'has the correct attributes' do
        expect(row.question).to    eq('.questions.penalty_level')
        expect(row.answer).to      eq('.answers.penalty_level.foo')
        expect(row.change_path).to be_nil
      end
    end
  end

  describe '`penalty_amount` question' do
    let(:row) { subject.penalty_amount_question }

    context 'when `penalty_amount` is nil' do
      let(:penalty_amount) { nil }

      it 'is not included' do
        expect(row).to be_nil
      end
    end

    context 'when `penalty_amount` is given' do
      let(:penalty_amount)  { 'about 12345' }

      it 'has the correct attributes' do
        expect(row.question).to    eq('.questions.penalty_amount')
        expect(row.answer).to      eq('about 12345')
        expect(row.change_path).to be_nil
      end
    end
  end

  describe '`tax_amount` question' do
    let(:row) { subject.tax_amount_question }

    context 'when `tax_amount` is nil' do
      let(:tax_amount) { nil }

      it 'is not included' do
        expect(row).to be_nil
      end
    end

    context 'when `tax_amount` is given' do
      let(:tax_amount)  { 'about 12345' }

      it 'has the correct attributes' do
        expect(row.question).to    eq('.questions.tax_amount')
        expect(row.answer).to      eq('about 12345')
        expect(row.change_path).to be_nil
      end
    end
  end

  describe '`disputed_tax_paid` question' do
    let(:row) { subject.disputed_tax_paid_question }

    context 'when `disputed_tax_paid` is nil' do
      let(:disputed_tax_paid) { nil }

      it 'is not included' do
        expect(row).to be_nil
      end
    end

    context 'when `disputed_tax_paid` is given' do
      let(:disputed_tax_paid)  { 'foo' }

      it 'has the correct attributes' do
        expect(row.question).to    eq('.questions.disputed_tax_paid')
        expect(row.answer).to      eq('.answers.disputed_tax_paid.foo')
        expect(row.change_path).to be_nil
      end
    end
  end

  describe '`hardship_review_requested` question' do
    let(:row) { subject.hardship_review_requested_question }

    context 'when `hardship_review_requested` is nil' do
      let(:hardship_review_requested) { nil }

      it 'is not included' do
        expect(row).to be_nil
      end
    end

    context 'when `hardship_review_requested` is given' do
      let(:hardship_review_requested)  { 'foo' }

      it 'has the correct attributes' do
        expect(row.question).to    eq('.questions.hardship_review_requested')
        expect(row.answer).to      eq('.answers.hardship_review_requested.foo')
        expect(row.change_path).to be_nil
      end
    end
  end

  describe '`hardship_review_status` row' do
    let(:row) { subject.hardship_review_status_question }

    context 'when `hardship_review_status` is nil' do
      let(:hardship_review_status) { nil }

      it 'is not included' do
        expect(row).to be_nil
      end
    end

    context 'when `hardship_review_status` is given' do
      let(:hardship_review_status) { 'foo' }

      it 'has the correct attributes' do
        expect(row.question).to    eq('.questions.hardship_review_status')
        expect(row.answer).to      eq('.answers.hardship_review_status.foo')
        expect(row.change_path).to be_nil
      end
    end
  end
end
