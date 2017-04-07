require 'spec_helper'

include ActionDispatch::TestProcess

RSpec.describe Steps::Hardship::HardshipReasonForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    hardship_reason: text_attribute_value,
    hardship_reason_document: document_attribute_value
  } }
  let(:tribunal_case) { instance_double(TribunalCase, files_collection_ref: '12345', hardship_reason: text_attribute_value) }
  let(:text_attribute_value) { nil }
  let(:document_attribute_value) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    it_behaves_like 'a document attachable step form', attribute_name: :hardship_reason
  end
end
