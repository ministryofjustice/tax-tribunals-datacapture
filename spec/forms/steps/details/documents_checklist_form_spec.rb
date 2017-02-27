require 'spec_helper'

RSpec.describe Steps::Details::DocumentsChecklistForm do
  let(:arguments) { {
      tribunal_case: tribunal_case,
      original_notice_provided: original_notice_provided,
      review_conclusion_provided: review_conclusion_provided,
      having_problems_uploading_documents: having_problems_uploading_documents,
      having_problems_uploading_details: having_problems_uploading_details
  } }

  let(:tribunal_case) { instance_double(TribunalCase) }

  let(:original_notice_provided) { true }
  let(:review_conclusion_provided) { true }
  let(:having_problems_uploading_documents) { false }
  let(:having_problems_uploading_details) { nil }
  let(:documents) { ['test.doc'] }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'validations on checkboxes' do
      before do
        allow(tribunal_case).to receive(:documents).with(:supporting_documents).and_return(documents)
      end

      context 'when no checkboxes are selected' do
        let(:original_notice_provided) { false }
        let(:review_conclusion_provided) { false }

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:original_notice_provided]).to_not be_empty
        end

        context 'unless having_problems_uploading_documents checkbox selected' do
          let(:having_problems_uploading_documents) { true }
          let(:having_problems_uploading_details) { 'my explanation' }

          it 'returns validations true' do
            expect(subject).to be_valid
          end
        end
      end

      context 'when no documents uploaded' do
        let(:documents) { [] }

        it 'has validation errors on the fields' do
          expect(subject).to_not be_valid
          expect(subject.errors[:original_notice_provided]).to_not be_empty
        end

        context 'unless having_problems_uploading_documents checkbox selected' do
          let(:having_problems_uploading_documents) { true }
          let(:having_problems_uploading_details) { 'my explanation' }

          it 'returns validations true' do
            expect(subject).to be_valid
          end
        end
      end

      context 'when having_problems_uploading_documents is selected' do
        let(:having_problems_uploading_documents) { true }

        context 'no explanation provided' do
          it 'has a validation error' do
            expect(subject).to_not be_valid
            expect(subject.errors[:having_problems_uploading_details]).to_not be_empty
          end
        end

        context 'explanation provided is too short' do
          let(:having_problems_uploading_details) { 'x' }

          it 'has a validation error' do
            expect(subject).to_not be_valid
            expect(subject.errors[:having_problems_uploading_details]).to_not be_empty
          end
        end

        context 'explanation provided is long enough' do
          let(:having_problems_uploading_details) { 'xx' }

          it 'has no validation errors' do
            expect(subject).to be_valid
          end
        end
      end
    end

    context 'when valid' do
      before do
        allow(tribunal_case).to receive(:documents).with(:supporting_documents).and_return(documents)
      end

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          original_notice_provided:             original_notice_provided,
          review_conclusion_provided:           review_conclusion_provided,
          having_problems_uploading_documents:  having_problems_uploading_documents,
          having_problems_uploading_details:    having_problems_uploading_details
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end
  end
end

