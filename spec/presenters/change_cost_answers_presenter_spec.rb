require 'spec_helper'

RSpec.describe ChangeCostAnswersPresenter do
  subject { described_class.new(tribunal_case) }
  let(:tribunal_case) {
    instance_double(
      TribunalCase,
      challenged_decision: challenged_decision,
      case_type: case_type,
      dispute_type: dispute_type,
      penalty_level: penalty_level,
      penalty_amount: penalty_amount,
      disputed_tax_paid: disputed_tax_paid,
      hardship_review_requested: hardship_review_requested,
      hardship_review_status: hardship_review_status
    )
  }
  let(:paths) { Rails.application.routes.url_helpers }

  let(:challenged_decision)       { true }
  let(:case_type)                 { 'foo' }
  let(:dispute_type)              { nil }
  let(:penalty_level)             { nil }
  let(:penalty_amount)            { nil }
  let(:disputed_tax_paid)         { nil }
  let(:hardship_review_requested) { nil }
  let(:hardship_review_status)    { nil }

  describe '#rows' do
    describe '`challenged_decision` row' do
      let(:row) { subject.rows.first }

      context 'when appeal is challenged' do
        let(:challenged_decision) { true }

        it 'has the correct attributes' do
          expect(row.question).to    eq('.questions.challenged_decision')
          expect(row.answer).to      eq('.answers.challenged_decision.true')
          expect(row.change_path).to eq(paths.edit_steps_cost_challenged_decision_path)
        end
      end

      context 'when appeal is unchallenged' do
        let(:challenged_decision) { false }

        it 'has the correct attributes' do
          expect(row.question).to    eq('.questions.challenged_decision')
          expect(row.answer).to      eq('.answers.challenged_decision.false')
          expect(row.change_path).to eq(paths.edit_steps_cost_challenged_decision_path)
        end
      end
    end

    describe '`case_type` row' do
      let(:row) { subject.rows.second }
      let(:case_type) { 'foo' }

      it 'has the correct attributes' do
        expect(row.question).to    eq('.questions.case_type')
        expect(row.answer).to      eq('.answers.case_type.foo')
        expect(row.change_path).to eq(paths.edit_steps_cost_case_type_path)
      end
    end

    describe '`dispute_type` row' do
      let(:row) { subject.rows[2] }

      context 'when `dispute_type` is nil' do
        let(:dispute_type) { nil }

        it 'is not included' do
          expect(row).to be_nil
        end
      end

      context 'when `case_type` is income_tax' do
        let(:dispute_type) { 'foo' }
        let(:case_type)  { 'income_tax' }

        it 'has the correct attributes' do
          expect(row.question).to    eq('.questions.dispute_type')
          expect(row.answer).to      eq('.answers.dispute_type.foo')
          expect(row.change_path).to eq(paths.edit_steps_cost_dispute_type_path)
        end
      end

      context 'when `case_type` is vat' do
        let(:dispute_type) { 'foo' }
        let(:case_type)  { 'vat' }

        it 'has the correct attributes' do
          expect(row.question).to    eq('.questions.dispute_type')
          expect(row.answer).to      eq('.answers.dispute_type.foo')
          expect(row.change_path).to eq(paths.edit_steps_cost_dispute_type_path)
        end
      end
    end

    describe '`penalty_level` row' do
      let(:row) { subject.rows[3] }

      # Needed so that the row is in the correct position
      let(:dispute_type) { 'foo' }
      let(:case_type) { 'bar' }

      context 'when `penalty_level` is nil' do
        let(:penalty_level) { nil }

        it 'is not included' do
          expect(row).to be_nil
        end
      end

      context 'when `penalty_level` is given' do
        let(:penalty_level)  { 'foo' }

        it 'has the correct attributes' do
          expect(row.question).to    eq('.questions.penalty_level')
          expect(row.answer).to      eq('.answers.penalty_level.foo')
          expect(row.change_path).to eq(paths.edit_steps_cost_penalty_amount_path)
        end
      end
    end

    describe '`penalty_amount` row' do
      let(:row) { subject.rows[4] }

      # Needed so that the row is in the correct position
      let(:dispute_type) { 'foo' }
      let(:case_type) { 'bar' }
      let(:penalty_level) { 'foo' }

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
          expect(row.change_path).to eq(paths.edit_steps_cost_penalty_amount_path)
        end
      end
    end

    describe '`disputed_tax_paid` row' do
      let(:row) { subject.rows[3] }

      # Needed so that the row is in the correct position
      let(:dispute_type) { 'foo' }
      let(:case_type) { 'bar' }

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
          expect(row.change_path).to eq(paths.edit_steps_hardship_disputed_tax_paid_path)
        end
      end
    end

    describe '`hardship_review_requested` row' do
      let(:row) { subject.rows[4] }

      # Needed so that the row is in the correct position
      let(:dispute_type) { 'foo' }
      let(:case_type) { 'bar' }
      let(:disputed_tax_paid) { 'baz' }

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
          expect(row.change_path).to eq(paths.edit_steps_hardship_hardship_review_requested_path)
        end
      end
    end

    describe '`hardship_review_status` row' do
      let(:row) { subject.rows[5] }

      # Needed so that the row is in the correct position
      let(:dispute_type) { 'foo' }
      let(:case_type) { 'bar' }
      let(:disputed_tax_paid) { 'baz' }
      let(:hardship_review_requested) { 'bam' }

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
          expect(row.change_path).to eq(paths.edit_steps_hardship_hardship_review_status_path)
        end
      end
    end
  end
end
