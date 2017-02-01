require 'spec_helper'

RSpec.describe Steps::Closure::SupportDocumentsForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    closure_problems_uploading_documents: closure_problems_uploading_documents,
    closure_problems_uploading_details: closure_problems_uploading_details
  } }

  let(:tribunal_case) { instance_double(TribunalCase, documents: documents) }

  let(:closure_problems_uploading_documents) { false }
  let(:closure_problems_uploading_details) { nil }
  let(:documents) { ['test.doc'] }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when no documents uploaded' do
      let(:documents) { [] }

      it 'returns validations true, as documents are optional' do
        expect(subject).to be_valid
      end
    end

    context 'when closure_problems_uploading_documents is selected' do
      let(:closure_problems_uploading_documents) { true }

      context 'no explanation provided' do
        it 'has a validation error' do
          expect(subject).to_not be_valid
          expect(subject.errors[:closure_problems_uploading_details]).to_not be_empty
        end
      end

      context 'explanation provided is too short' do
        let(:closure_problems_uploading_details) { 'x' }

        it 'has a validation error' do
          expect(subject).to_not be_valid
          expect(subject.errors[:closure_problems_uploading_details]).to_not be_empty
        end
      end

      context 'explanation provided is long enough' do
        let(:closure_problems_uploading_details) { 'xx' }

        it 'has no validation errors' do
          expect(subject).to be_valid
        end
      end
    end

    context 'when valid' do
      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          closure_problems_uploading_documents: closure_problems_uploading_documents,
          closure_problems_uploading_details: closure_problems_uploading_details
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end
  end
end
