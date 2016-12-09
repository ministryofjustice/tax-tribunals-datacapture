require 'spec_helper'

RSpec.describe Steps::Details::DocumentsChecklistForm do
  let(:arguments) { {
      tribunal_case: tribunal_case,
      original_notice_provided: original_notice_provided,
      review_conclusion_provided: review_conclusion_provided,
      additional_documents_provided: additional_documents_provided,
      additional_documents_info: additional_documents_info,
      having_problems_uploading_documents: having_problems_uploading_documents
  } }

  let(:tribunal_case) { instance_double(TribunalCase, documents: documents) }

  let(:original_notice_provided) { true }
  let(:review_conclusion_provided) { true }
  let(:additional_documents_provided) { true }
  let(:additional_documents_info) { 'details here' }
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

      context 'when additional_documents_provided selected but not additional info filled' do
        let(:additional_documents_provided) { true }
        let(:additional_documents_info) { nil }

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:additional_documents_info]).to eq(['You must describe the additional uploaded documents. Use at least 5 characters.'])
        end
      end

      context 'when additional_documents_provided is not selected but additional info was filled' do
        let(:additional_documents_provided) { nil }
        let(:additional_documents_info) { 'details here' }

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:additional_documents_info]).to eq(['Must be blank unless uploading additional documents'])
        end
      end

      context 'when additional_documents_info does not meet the length requirements' do
        let(:additional_documents_provided) { true }
        let(:additional_documents_info) { 'hi' }

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:additional_documents_info]).to eq(['You must describe the additional uploaded documents. Use at least 5 characters.'])
        end
      end

      context 'when no documents uploaded' do
        let(:documents) { [] }

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:original_notice_provided]).to eq(['Please ensure the documents are uploaded'])
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
          additional_documents_provided:        additional_documents_provided,
          additional_documents_info:            additional_documents_info,
          having_problems_uploading_documents:  having_problems_uploading_documents
        )
        expect(subject.save).to be(true)
      end
    end
  end
end

