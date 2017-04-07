require 'spec_helper'

RSpec.describe Steps::Closure::AdditionalInfoForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    closure_additional_info: text_attribute_value,
    closure_additional_info_document: document_attribute_value,
  } }
  let(:tribunal_case) { instance_double(TribunalCase, files_collection_ref: '12345', closure_additional_info: text_attribute_value) }
  let(:text_attribute_value) { nil }
  let(:document_attribute_value) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    it_behaves_like 'a document attachable optional step form', attribute_name: :closure_additional_info
  end
end
