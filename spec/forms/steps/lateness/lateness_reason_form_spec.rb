require 'spec_helper'

RSpec.describe Steps::Lateness::LatenessReasonForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    lateness_reason: text_attribute_value,
    lateness_reason_document: document_attribute_value,
  } }
  let(:tribunal_case) { instance_double(TribunalCase, lateness_reason: text_attribute_value, in_time: in_time, files_collection_ref: '12345') }
  let(:text_attribute_value) { nil }
  let(:document_attribute_value) { nil }
  let(:in_time) { nil }

  subject { described_class.new(arguments) }

  describe '#lateness_unknown?' do
    context 'when appeal is not late' do
      let(:in_time) { InTime::YES }

      it 'should return false' do
        expect(subject.lateness_unknown?).to be(false)
      end
    end

    context 'when appeal is late' do
      let(:in_time) { InTime::NO }

      it 'should return false' do
        expect(subject.lateness_unknown?).to be(false)
      end
    end

    context 'when appellant is not sure' do
      let(:in_time) { InTime::UNSURE }

      it 'should return false' do
        expect(subject.lateness_unknown?).to be(true)
      end
    end
  end

  describe '#save' do
    it_behaves_like 'a document attachable step form', attribute_name: :lateness_reason
  end
end
