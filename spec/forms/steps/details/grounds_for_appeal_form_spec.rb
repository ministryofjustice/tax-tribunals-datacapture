require 'spec_helper'

include ActionDispatch::TestProcess

RSpec.describe Steps::Details::GroundsForAppealForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    grounds_for_appeal: grounds_for_appeal,
    grounds_for_appeal_document: grounds_for_appeal_document,
  } }
  let(:tribunal_case) { instance_double(TribunalCase, files_collection_ref: '12345', grounds_for_appeal: nil, grounds_for_appeal_file_name: nil) }
  let(:grounds_for_appeal) { nil }
  let(:grounds_for_appeal_document) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case)  { nil }
      let(:grounds_for_appeal) { 'value' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when validations fail' do
      context 'when grounds_for_appeal and grounds_for_appeal_document are not present' do
        let(:grounds_for_appeal) { nil }

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the grounds_for_appeal field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:grounds_for_appeal]).to eq(['You must enter the reasons or attach a document'])
        end

        it 'has a validation error on the grounds_for_appeal_document field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:grounds_for_appeal_document]).to eq(['You must enter the reasons or attach a document'])
        end
      end

      context 'when grounds_for_appeal_document is not valid' do
        let(:grounds_for_appeal_document) { fixture_file_upload('files/image.jpg', 'application/zip') }

        it 'should retrieve the errors from the uploader' do
          expect(subject.errors).to receive(:add).with(:grounds_for_appeal_document, :content_type).and_call_original
          expect(subject).to_not be_valid
        end
      end
    end

    context 'when grounds_for_appeal is valid' do
      context 'when providing appeal text' do
        let(:grounds_for_appeal) { 'I disagree with HMRC.' }
        let(:grounds_for_appeal_document) { nil }

        it 'saves the record' do
          expect(tribunal_case).to receive(:update).with(
            grounds_for_appeal: 'I disagree with HMRC.',
            grounds_for_appeal_file_name: nil)
          expect(subject.save).to be(true)
        end
      end

      context 'when providing an attached document' do
        let(:grounds_for_appeal) { nil }
        let(:grounds_for_appeal_document) { fixture_file_upload('files/image.jpg', 'image/jpeg')  }
        let(:upload_response) { double(code: 200, body: {}, error?: false) }

        it 'saves the record' do
          expect(tribunal_case).to receive(:update).with(
            grounds_for_appeal: nil,
            grounds_for_appeal_file_name: 'image.jpg')

          expect(MojFileUploaderApiClient::AddFile).to receive(:new).and_return(double(call: upload_response))

          expect(subject.save).to be(true)
        end
      end

      context 'when providing appeal text and document' do
        let(:grounds_for_appeal) { 'I disagree with HMRC.' }
        let(:grounds_for_appeal_document) { fixture_file_upload('files/image.jpg', 'image/jpeg')  }
        let(:upload_response) { double(code: 200, body: {}, error?: false) }

        it 'saves the record' do
          expect(tribunal_case).to receive(:update).with(
            grounds_for_appeal: 'I disagree with HMRC.',
            grounds_for_appeal_file_name: 'image.jpg')

          expect(MojFileUploaderApiClient::AddFile).to receive(:new).and_return(double(call: upload_response))

          expect(subject.save).to be(true)
        end
      end
    end
  end
end

