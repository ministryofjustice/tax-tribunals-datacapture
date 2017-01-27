require 'spec_helper'

RSpec.describe FeeDetailsAnswersPresenter do
  subject { described_class.new(tribunal_case) }

  let(:tribunal_case) { TribunalCase.create }

  let(:declared_rows) {
    [
      :challenged_decision_question,
      :case_type_question,
      :dispute_type_question,
      :challenged_decision_status_question,
      :penalty_level_question,
      :penalty_amount_question,
      :tax_amount_question,
      :fee_amount_question,
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
end
