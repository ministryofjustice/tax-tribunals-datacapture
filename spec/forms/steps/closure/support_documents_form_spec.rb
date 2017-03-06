require 'spec_helper'

RSpec.describe Steps::Closure::SupportDocumentsForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    having_problems_uploading_documents: having_problems_uploading_documents,
    having_problems_uploading_details: having_problems_uploading_details
  } }

  let(:tribunal_case) { instance_double(TribunalCase, documents: documents) }

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

    context 'when no documents uploaded' do
      let(:documents) { [] }

      it 'returns validations true, as documents are optional' do
        expect(subject).to be_valid
      end
    end

    context 'when having_problems_uploading_documents is not selected' do
      let(:having_problems_uploading_documents) { false }
      it { should_not validate_presence_of(:having_problems_uploading_details) }
    end

    context 'when having_problems_uploading_documents is selected' do
      let(:having_problems_uploading_documents) { true }
      it { should validate_presence_of(:having_problems_uploading_details) }
    end

    context 'when valid' do
      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          having_problems_uploading_documents: having_problems_uploading_documents,
          having_problems_uploading_details: having_problems_uploading_details
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end
  end
end
