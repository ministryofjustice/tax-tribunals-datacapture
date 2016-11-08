require 'rails_helper'

RSpec.describe ChangeCostAnswersPresenter do
  subject { described_class.new(tribunal_case) }
  let(:tribunal_case) {
    instance_double(
      TribunalCase,
      did_challenge_hmrc:                  did_challenge_hmrc,
      case_type:                case_type,
      what_is_dispute_about:               what_is_dispute_about,
      what_is_penalty_or_surcharge_amount: what_is_penalty_or_surcharge_amount
    )
  }
  let(:paths) { Rails.application.routes.url_helpers }

  let(:did_challenge_hmrc)                  { true }
  let(:case_type)                { 'foo' }
  let(:what_is_dispute_about)               { nil }
  let(:what_is_penalty_or_surcharge_amount) { nil }

  describe '#rows' do
    describe '`did_challenge_hmrc` row' do
      let(:row) { subject.rows.first }

      context 'when appeal is challenged' do
        let(:did_challenge_hmrc) { true }

        it 'has the correct attributes' do
          expect(row.question).to    eq('.questions.did_challenge_hmrc')
          expect(row.answer).to      eq('.answers.did_challenge_hmrc.true')
          expect(row.change_path).to eq(paths.edit_steps_did_challenge_hmrc_path)
        end
      end

      context 'when appeal is unchallenged' do
        let(:did_challenge_hmrc) { false }

        it 'has the correct attributes' do
          expect(row.question).to    eq('.questions.did_challenge_hmrc')
          expect(row.answer).to      eq('.answers.did_challenge_hmrc.false')
          expect(row.change_path).to eq(paths.edit_steps_did_challenge_hmrc_path)
        end
      end
    end

    describe '`case_type` row' do
      let(:row) { subject.rows.second }
      let(:case_type) { 'foo' }

      context 'when appeal is challenged' do
        let(:did_challenge_hmrc) { true }

        it 'has the correct attributes' do
          expect(row.question).to    eq('.questions.case_type')
          expect(row.answer).to      eq('.answers.case_type.foo')
          expect(row.change_path).to eq(paths.edit_steps_case_type_challenged_path)
        end
      end

      context 'when appeal is unchallenged' do
        let(:did_challenge_hmrc) { false }

        it 'has the correct attributes' do
          expect(row.question).to    eq('.questions.case_type')
          expect(row.answer).to      eq('.answers.case_type.foo')
          expect(row.change_path).to eq(paths.edit_steps_case_type_unchallenged_path)
        end
      end
    end

    describe '`what_is_dispute_about` row' do
      let(:row) { subject.rows[2] }

      context 'when `what_is_dispute_about` is nil' do
        let(:what_is_dispute_about) { nil }

        it 'is not included' do
          expect(row).to be_nil
        end
      end

      context 'when `case_type` is income_tax' do
        let(:what_is_dispute_about) { 'foo' }
        let(:case_type)  { 'income_tax' }

        it 'has the correct attributes' do
          expect(row.question).to    eq('.questions.what_is_dispute_about')
          expect(row.answer).to      eq('.answers.what_is_dispute_about.foo')
          expect(row.change_path).to eq(paths.edit_steps_what_is_dispute_about_path)
        end
      end

      context 'when `case_type` is vat' do
        let(:what_is_dispute_about) { 'foo' }
        let(:case_type)  { 'vat' }

        it 'has the correct attributes' do
          expect(row.question).to    eq('.questions.what_is_dispute_about')
          expect(row.answer).to      eq('.answers.what_is_dispute_about.foo')
          expect(row.change_path).to eq(paths.edit_steps_what_is_dispute_about_path)
        end
      end
    end

    describe '`what_is_penalty_or_surcharge_amount` row' do
      let(:row) { subject.rows[3] }

      # Needed so that the row is in the correct position
      let(:what_is_dispute_about) { 'foo' }
      let(:case_type)  { 'bar' }

      context 'when `what_is_penalty_or_surcharge_amount` is nil' do
        let(:what_is_penalty_or_surcharge_amount) { nil }

        it 'is not included' do
          expect(row).to be_nil
        end
      end

      context 'when `what_is_penalty_or_surcharge_amount` is given' do
        let(:what_is_penalty_or_surcharge_amount)  { 'foo' }

        it 'has the correct attributes' do
          expect(row.question).to    eq('.questions.what_is_penalty_or_surcharge_amount')
          expect(row.answer).to      eq('.answers.what_is_penalty_or_surcharge_amount.foo')
          expect(row.change_path).to eq(paths.edit_steps_what_is_late_penalty_or_surcharge_path)
        end
      end
    end
  end
end
