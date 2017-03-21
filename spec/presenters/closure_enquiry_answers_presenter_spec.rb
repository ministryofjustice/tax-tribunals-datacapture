require 'spec_helper'

RSpec.describe ClosureEnquiryAnswersPresenter do
  subject { described_class.new(tribunal_case) }

  let(:tribunal_case) {
    instance_double(
      TribunalCase,
      closure_hmrc_reference: closure_hmrc_reference,
      closure_years_under_enquiry: closure_years_under_enquiry,
      closure_hmrc_officer: closure_hmrc_officer,
      closure_additional_info: closure_additional_info
    )
  }

  let(:paths) { Rails.application.routes.url_helpers }

  let(:closure_hmrc_reference)      { 'reference' }
  let(:closure_years_under_enquiry) { '2 years' }
  let(:closure_hmrc_officer)        { nil }
  let(:closure_additional_info)     { nil }

  describe '#rows' do
    describe '`closure_hmrc_reference` row' do
      let(:row) { subject.rows[0] }

      it 'has the correct attributes' do
        expect(row.question).to    eq('.questions.hmrc_reference')
        expect(row.answer).to      eq('reference')
        expect(row.change_path).to eq(paths.edit_steps_closure_enquiry_details_path)
      end
    end

    describe '`closure_years_under_enquiry` row' do
      let(:row) { subject.rows[1] }

      it 'has the correct attributes' do
        expect(row.question).to    eq('.questions.years_under_enquiry')
        expect(row.answer).to      eq('2 years')
        expect(row.change_path).to be_nil
      end
    end

    describe '`closure_hmrc_officer` row' do
      let(:row) { subject.rows[2] }

      context 'when present' do
        let(:closure_hmrc_officer) { 'officer' }

        it 'has the correct attributes' do
          expect(row.question).to    eq('.questions.hmrc_officer')
          expect(row.answer).to      eq('officer')
          expect(row.change_path).to be_nil
        end
      end

      context 'when no present' do
        it 'has no row' do
          expect(row).to be_nil
        end
      end
    end
  end

  describe '#additional_info' do
    context 'when present' do
      let(:closure_additional_info) { 'more info' }

      it 'has the correct attributes' do
        expect(subject.additional_info.question).to    eq('.questions.additional_info')
        expect(subject.additional_info.answer).to      eq('more info')
        expect(subject.additional_info.change_path).to eq(paths.edit_steps_closure_additional_info_path)
      end
    end

    context 'when no present' do
      let(:closure_additional_info) { nil }

      it 'has no row' do
        expect(subject.additional_info).to be_nil
      end
    end
  end
end
