require 'spec_helper'

include ActionDispatch::TestProcess

RSpec.describe Steps::Hardship::HardshipReasonForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    hardship_reason: hardship_reason,
    hardship_reason_document: hardship_reason_document,
  } }
  let(:tribunal_case) { instance_double(TribunalCase, files_collection_ref: '12345', hardship_reason: hardship_reason, hardship_reason_file_name: hardship_reason_file_name) }
  let(:hardship_reason) { nil }
  let(:hardship_reason_document) { nil }
  let(:hardship_reason_file_name) { nil }

  subject { described_class.new(arguments) }

  before do
    # Used to retrieve already uploaded files and detect duplicates, but not part of these tests, so stubbing it
    allow(Uploader).to receive(:list_files).and_return([])
  end

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case)  { nil }
      let(:hardship_reason) { 'Hardship Reason' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when validations fail' do
      context 'when hardship_reason nor hardship_reason_document are present' do
        let(:hardship_reason) { nil }

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the hardship_reason field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:hardship_reason]).to eq(['You must enter reasons or attach a document'])
        end
      end

      context 'when hardship_reason_document is not valid' do
        let(:hardship_reason_document) { fixture_file_upload('files/image.jpg', 'application/zip') }

        it 'should retrieve the errors from the uploader' do
          expect(subject.errors).to receive(:add).with(:hardship_reason_document, :content_type).and_call_original
          expect(subject).to_not be_valid
        end
      end
    end

    context 'when hardship_reason is valid' do
      context 'when providing appeal text' do
        let(:hardship_reason) { 'I disagree with HMRC.' }
        let(:hardship_reason_document) { nil }

        it 'saves the record' do
          expect(tribunal_case).to receive(:update).with(
            hardship_reason: 'I disagree with HMRC.',
            hardship_reason_file_name: nil
          ).and_return(true)
          expect(subject.save).to be(true)
        end
      end

      context 'when providing an attached document' do
        let(:hardship_reason) { nil }
        let(:hardship_reason_document) { fixture_file_upload('files/image.jpg', 'image/jpeg')  }

        context 'document upload successful' do
          it 'saves the record' do
            expect(tribunal_case).to receive(:update).with(
              hardship_reason: nil,
              hardship_reason_file_name: 'image.jpg'
            ).and_return(true)

            expect(Uploader).to receive(:add_file).with(hash_including(document_key: :hardship_reason)).and_return({})

            expect(subject.save).to be(true)
          end
        end

        context 'document upload unsuccessful' do
          it 'doesn\'t save the record' do
            expect(tribunal_case).not_to receive(:update)
            expect(subject).to receive(:upload_document_if_present).and_return(false)
            expect(subject.save).to be(false)
          end
        end
      end

      context 'when providing appeal text and document' do
        let(:hardship_reason) { 'A very good reason' }
        let(:hardship_reason_document) { fixture_file_upload('files/image.jpg', 'image/jpeg')  }
        let(:upload_response) { double(code: 200, body: {}, error?: false) }

        it 'saves the record' do
          expect(tribunal_case).to receive(:update).with(
            hardship_reason: 'A very good reason',
            hardship_reason_file_name: 'image.jpg'
          ).and_return(true)

          expect(Uploader).to receive(:add_file).and_return({})

          expect(subject.save).to be(true)
        end
      end
    end
  end
end

