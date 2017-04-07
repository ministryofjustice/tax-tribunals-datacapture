require 'rails_helper'

RSpec.shared_examples 'common scenarios for a document attachable step form' do
  let(:documents) { [] }

  before do
    # Used to retrieve already uploaded files and detect duplicates, but not part of these tests, so stubbing it
    allow(Uploader).to receive(:list_files).and_return([])
  end

  context 'when no tribunal_case is associated with the form' do
    let(:tribunal_case) { nil }
    let(:text_attribute_value) { 'value' }

    it 'raises an error' do
      expect { subject.save }.to raise_error(RuntimeError)
    end
  end

  context 'when form is valid' do
    before do
      allow(tribunal_case).to receive(:documents).with(attribute_name).and_return(documents)
    end

    context 'when providing appeal text' do
      let(:text_attribute_value) { 'I disagree with HMRC.' }
      let(:document_attribute_value) { nil }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
            attribute_name => 'I disagree with HMRC.'
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end

    context 'when providing an attached document' do
      let(:text_attribute_value) { nil }
      let(:document_attribute_value) { fixture_file_upload('files/image.jpg', 'image/jpeg') }

      context 'document upload successful' do
        it 'saves the record' do
          expect(tribunal_case).to receive(:update).with(
              attribute_name => nil
          ).and_return(true)

          expect(Uploader).to receive(:add_file).with(hash_including(document_key: attribute_name)).and_return({})

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
      let(:text_attribute_value) { 'I disagree with HMRC.' }
      let(:document_attribute_value) { fixture_file_upload('files/image.jpg', 'image/jpeg') }
      let(:upload_response) { double(code: 200, body: {}, error?: false) }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
            attribute_name => 'I disagree with HMRC.'
        ).and_return(true)

        expect(Uploader).to receive(:add_file).and_return({})

        expect(subject.save).to be(true)
      end
    end
  end
end

RSpec.shared_examples 'a document attachable step form' do |options|
  let(:attribute_name) { options.fetch(:attribute_name) }  # i.e. grounds_for_appeal
  let(:document_attribute_name) { [attribute_name, '_document'].join.to_sym }  # i.e. grounds_for_appeal_document

  include_examples 'common scenarios for a document attachable step form'

  context 'validations' do
    before do
      allow(tribunal_case).to receive(:documents).with(attribute_name).and_return(documents)
    end

    context 'when text nor document are present' do
      let(:text_attribute_value) { nil }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the text field' do
        expect(subject).to_not be_valid
        expect(subject.errors[attribute_name]).to eq(['You must enter reasons or attach a document'])
      end
    end

    context 'when document is not valid' do
      let(:document_attribute_value) { fixture_file_upload('files/image.jpg', 'application/zip') }

      it 'should retrieve the errors from the uploader' do
        expect(subject.errors).to receive(:add).with(document_attribute_name, :content_type).and_call_original
        expect(subject).to_not be_valid
      end
    end
  end
end

RSpec.shared_examples 'a document attachable optional step form' do |options|
  let(:attribute_name) { options.fetch(:attribute_name) }  # i.e. grounds_for_appeal
  let(:document_attribute_name) { [attribute_name, '_document'].join.to_sym }  # i.e. grounds_for_appeal_document

  include_examples 'common scenarios for a document attachable step form'
end
