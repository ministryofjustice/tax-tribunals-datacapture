require 'spec_helper'

RSpec.describe Steps::Details::DocumentsChecklistForm do
  let(:arguments) { {
      tribunal_case: tribunal_case,
      original_notice_provided: original_notice_provided,
      review_conclusion_provided: review_conclusion_provided,
      having_problems_uploading_documents: having_problems_uploading_documents
  } }

  let(:tribunal_case) { instance_double(TribunalCase, documents: documents) }

  let(:original_notice_provided) { true }
  let(:review_conclusion_provided) { true }
  let(:having_problems_uploading_documents) { false }
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
      context 'when original_notice_provided is not selected' do
        let(:original_notice_provided) { nil }

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:original_notice_provided]).to eq(['You must upload and check this document type'])
        end

        context 'unless having_problems_uploading_documents checkbox selected' do
          let(:having_problems_uploading_documents) { true }

          it 'returns validations true' do
            expect(subject).to be_valid
          end
        end
      end

      context 'when review_conclusion_provided is not selected' do
        let(:review_conclusion_provided) { nil }

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:review_conclusion_provided]).to eq(['You must upload and check this document type'])
        end

        context 'unless having_problems_uploading_documents checkbox selected' do
          let(:having_problems_uploading_documents) { true }

          it 'returns validations true' do
            expect(subject).to be_valid
          end
        end
      end

      context 'when no documents uploaded' do
        let(:documents) { [] }

        it 'has validation errors on the fields' do
          expect(subject).to_not be_valid
          expect(subject.errors[:original_notice_provided]).to eq(['Please ensure the documents are uploaded'])
          expect(subject.errors[:review_conclusion_provided]).to eq(['Please ensure the documents are uploaded'])
        end

        context 'unless having_problems_uploading_documents checkbox selected' do
          let(:having_problems_uploading_documents) { true }

          it 'returns validations true' do
            expect(subject).to be_valid
          end
        end
      end
    end

    context 'when valid' do
      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          original_notice_provided:             original_notice_provided,
          review_conclusion_provided:           review_conclusion_provided,
          having_problems_uploading_documents:  having_problems_uploading_documents
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end
  end
end

