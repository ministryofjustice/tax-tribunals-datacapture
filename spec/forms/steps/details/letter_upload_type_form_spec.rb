require 'spec_helper'

RSpec.describe Steps::Details::LetterUploadTypeForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    letter_upload_type: letter_upload_type
  } }
  let(:tribunal_case) { instance_double(TribunalCase, letter_upload_type: letter_upload_type) }
  let(:letter_upload_type) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case)  { nil }
      let(:letter_upload_type) { 'single' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when `letter_upload_type` is not given' do
      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:letter_upload_type]).to_not be_empty
      end
    end

    context 'when `letter_upload_type` is not valid' do
      let(:letter_upload_type) { 'whatever' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:letter_upload_type]).to_not be_empty
      end
    end

    context 'when `letter_upload_type` is valid' do
      let(:letter_upload_type) { 'single' }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          letter_upload_type: LetterUploadType::SINGLE,
          having_problems_uploading: false,
          having_problems_uploading_explanation: nil
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end

    context 'when `letter_upload_type` is already the same on the model' do
      let(:tribunal_case) {
        instance_double(
          TribunalCase,
          letter_upload_type: LetterUploadType::SINGLE
        )
      }
      let(:letter_upload_type) { 'single' }

      it 'does not save the record but returns true' do
        expect(tribunal_case).to_not receive(:update)
        expect(subject.save).to be(true)
      end
    end
  end
end

