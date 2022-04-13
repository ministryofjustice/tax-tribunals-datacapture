require 'spec_helper'

RSpec.describe Steps::Details::RepresentativeApprovalForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    representative_approval_document: representative_approval_document
  } }
  let(:tribunal_case) { instance_double(TribunalCase, files_collection_ref: 'ABC123') }
  let(:representative_approval_document) { nil }

  subject { described_class.new(arguments) }

  before do
    # Used to retrieve already uploaded files and detect duplicates, but not part of these tests, so stubbing it
    allow(Uploader).to receive(:list_files).and_return([])
  end

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case)  { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when no document has been provided' do
      let(:representative_approval_document) { nil }

      it 'returns true' do
        expect(subject.save).to eq(true)
      end
    end

    context 'when a document has been provided' do
      context 'and it is not valid' do
        let(:representative_approval_document) { fixture_file_upload('files/image.jpg', 'application/zip') }

        it 'should retrieve the errors from the uploader' do
          expect(subject.errors).to receive(:add).with(:representative_approval_document, :content_type).and_call_original
          expect(subject).to_not be_valid
        end
      end

      context 'and it is valid' do
        let(:representative_approval_document) { fixture_file_upload('files/image.jpg', 'image/jpeg')  }

        context 'document upload successful' do
          it 'uploads the file' do
            expect(Uploader).to receive(:add_file).
              with(hash_including(document_key: :representative_approval)).
              and_return(double(name: '123/foo/bar.png'))
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

