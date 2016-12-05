require 'spec_helper'

RSpec.describe Steps::Details::GroundsForAppealForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    grounds_for_appeal: grounds_for_appeal,
    grounds_for_appeal_document: grounds_for_appeal_document,
    grounds_for_appeal_file_name: grounds_for_appeal_file_name
  } }
  let(:tribunal_case) { instance_double(TribunalCase, grounds_for_appeal: nil) }
  let(:grounds_for_appeal) { nil }
  let(:grounds_for_appeal_document) { nil }
  let(:grounds_for_appeal_file_name) { nil }

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
    end

    context 'when grounds_for_appeal is valid' do
      context 'when providing appeal text' do
        let(:grounds_for_appeal) { 'I disagree with HMRC.' }
        let(:grounds_for_appeal_file_name) { nil }

        it 'saves the record' do
          expect(tribunal_case).to receive(:update).with(
            grounds_for_appeal: grounds_for_appeal,
            grounds_for_appeal_file_name: grounds_for_appeal_file_name)
          expect(subject.save).to be(true)
        end
      end

      context 'when providing an attached document' do
        let(:grounds_for_appeal) { nil }
        let(:grounds_for_appeal_file_name) { 'name.txt' }

        it 'saves the record' do
          expect(tribunal_case).to receive(:update).with(
            grounds_for_appeal: grounds_for_appeal,
            grounds_for_appeal_file_name: grounds_for_appeal_file_name)
          expect(subject.save).to be(true)
        end
      end

      context 'when providing appeal text and document' do
        let(:grounds_for_appeal) { 'I disagree with HMRC.' }
        let(:grounds_for_appeal_file_name) { 'name.txt' }

        it 'saves the record' do
          expect(tribunal_case).to receive(:update).with(
            grounds_for_appeal: grounds_for_appeal,
            grounds_for_appeal_file_name: grounds_for_appeal_file_name)
          expect(subject.save).to be(true)
        end
      end
    end
  end
end

