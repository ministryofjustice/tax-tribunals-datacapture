require 'spec_helper'

RSpec.describe HardshipAnswersPresenter do
  subject { described_class.new(tribunal_case) }
  let(:tribunal_case) {
    instance_double(
      TribunalCase,
      disputed_tax_paid: disputed_tax_paid,
      hardship_review_requested: hardship_review_requested,
      hardship_review_status: hardship_review_status
    )
  }
  let(:paths) { Rails.application.routes.url_helpers }

  let(:disputed_tax_paid)         { nil }
  let(:hardship_review_requested) { nil }
  let(:hardship_review_status)    { nil }

  describe '#show_reason?' do
    let(:tribunal_case) { instance_double(TribunalCase, hardship_review_status: hardship_review_status) }

    context 'when the hardship status is refused' do
      let(:hardship_review_status) { HardshipReviewStatus::REFUSED }
      it { expect(subject.show_reason?).to eq(true) }
    end

    context 'when the hardship status is other than refused' do
      let(:hardship_review_status) { HardshipReviewStatus::GRANTED }
      it { expect(subject.show_reason?).to eq(false) }
    end
  end

  describe '#rows' do
    describe '`disputed_tax_paid` question' do
      let(:row) { subject.rows[0] }

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
      let(:row) { subject.rows[1] }
      let(:disputed_tax_paid) { 'foo' }

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
      let(:row) { subject.rows[2] }
      let(:disputed_tax_paid) { 'foo' }
      let(:hardship_review_requested)  { 'foo' }

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
end
