require 'spec_helper'

include ActionDispatch::TestProcess

RSpec.describe Steps::Details::LetterUploadForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    original_notice_letter_document: original_notice_letter_document,
    having_problems_uploading: having_problems_uploading,
    having_problems_uploading_explanation: having_problems_uploading_explanation
  } }

  let(:tribunal_case) { instance_double(TribunalCase, files_collection_ref: 'ABC123') }

  let(:original_notice_letter_document) { nil }
  let(:having_problems_uploading) { false }
  let(:having_problems_uploading_explanation) { nil }

  subject { described_class.new(arguments) }

  before do
    allow(tribunal_case).to receive(:documents).with(:original_notice_letter)
    allow(tribunal_case).to receive(:having_problems_uploading=).with(having_problems_uploading)
    # Used to retrieve already uploaded files and detect duplicates, but not part of these tests, so stubbing it
    allow(Uploader).to receive(:list_files).and_return([])
  end

  describe '#save' do
    context 'when having_problems_uploading is not selected' do
      let(:having_problems_uploading) { false }
      it { should_not validate_presence_of(:having_problems_uploading_explanation) }
    end

    context 'when having_problems_uploading is selected' do
      let(:having_problems_uploading) { true }
      it { should validate_presence_of(:having_problems_uploading_explanation) }
    end

    context 'when no document has been provided' do
      let(:original_notice_letter_document) { nil }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the text field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:original_notice_letter_document]).to eq(['You must upload a file'])
      end

      context 'unless having_problems_uploading checkbox selected' do
        let(:having_problems_uploading) { true }
        let(:having_problems_uploading_explanation) { 'my explanation' }

        it 'returns validations true' do
          expect(subject).to be_valid
        end
      end
    end

    context 'when a document has been provided' do
      context 'and it is not valid' do
        let(:original_notice_letter_document) { fixture_file_upload('files/image.jpg', 'application/zip') }

        it 'should retrieve the errors from the uploader' do
          expect(subject.errors).to receive(:add).with(:original_notice_letter_document, :content_type).and_call_original
          expect(subject).to_not be_valid
        end
      end

      context 'and it is valid' do
        let(:original_notice_letter_document) { fixture_file_upload('files/image.jpg', 'image/jpeg')  }

        context 'document upload successful' do
          it 'uploads the file' do
            expect(Uploader).to receive(:add_file).with(hash_including(document_key: :original_notice_letter)).and_return({})

            expect(tribunal_case).to receive(:update).with(
              having_problems_uploading: having_problems_uploading,
              having_problems_uploading_explanation: having_problems_uploading_explanation
            ).and_return(true)

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
    end
  end
end
