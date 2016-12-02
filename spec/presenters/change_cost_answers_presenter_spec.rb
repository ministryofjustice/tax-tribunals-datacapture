require 'spec_helper'

RSpec.describe ChangeCostAnswersPresenter do
  subject { described_class.new(tribunal_case) }
  let(:tribunal_case) {
    instance_double(
      TribunalCase,
      challenged_decision:                  challenged_decision,
      case_type:                case_type,
      dispute_type:               dispute_type,
      penalty_amount: penalty_amount
    )
  }
  let(:paths) { Rails.application.routes.url_helpers }

  let(:challenged_decision) { true }
  let(:case_type)           { 'foo' }
  let(:dispute_type)        { nil }
  let(:penalty_amount)      { nil }

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

    describe '`penalty_amount` row' do
      let(:row) { subject.rows[3] }

      # Needed so that the row is in the correct position
      let(:dispute_type) { 'foo' }
      let(:case_type)  { 'bar' }

      context 'when `penalty_amount` is nil' do
        let(:penalty_amount) { nil }

        it 'is not included' do
          expect(row).to be_nil
        end
      end

      context 'when `penalty_amount` is given' do
        let(:penalty_amount)  { 'foo' }

        it 'has the correct attributes' do
          expect(row.question).to    eq('.questions.penalty_amount')
          expect(row.answer).to      eq('.answers.penalty_amount.foo')
          expect(row.change_path).to eq(paths.edit_steps_cost_penalty_amount_path)
        end
      end
    end
  end
end
