require 'spec_helper'

RSpec.describe Steps::Hardship::HardshipReviewRequestedForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    hardship_review_requested: hardship_review_requested
  } }
  let(:tribunal_case) { instance_double(TribunalCase, hardship_review_requested: nil) }
  let(:hardship_review_requested) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case) { nil }
      let(:hardship_review_requested) { 'no' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when hardship_review_requested is not given' do
      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:hardship_review_requested]).to_not be_empty
      end
    end

    context 'when hardship_review_requested is not valid' do
      let(:hardship_review_requested) { 'kinda' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:hardship_review_requested]).to_not be_empty
      end
    end

    context 'when hardship_review_requested is valid' do
      let(:hardship_review_requested) { 'yes' }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          hardship_review_requested: HardshipReviewRequested::YES,
          hardship_review_status: nil
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end

    context 'when hardship_review_requested is already the same on the model' do
      let(:tribunal_case) {
        instance_double(
          TribunalCase,
          hardship_review_requested: HardshipReviewRequested::NO
        )
      }
      let(:hardship_review_requested) { 'no' }

      it 'does not save the record but returns true' do
        expect(tribunal_case).to_not receive(:update)
        expect(subject.save).to be(true)
      end
    end
  end
end

