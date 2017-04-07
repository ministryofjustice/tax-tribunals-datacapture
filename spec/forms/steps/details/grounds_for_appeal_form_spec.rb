require 'spec_helper'

include ActionDispatch::TestProcess

RSpec.describe Steps::Details::GroundsForAppealForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    grounds_for_appeal: text_attribute_value,
    grounds_for_appeal_document: document_attribute_value,
  } }
  let(:tribunal_case) { instance_double(TribunalCase, files_collection_ref: '12345', grounds_for_appeal: text_attribute_value) }
  let(:text_attribute_value) { nil }
  let(:document_attribute_value) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    it_behaves_like 'a document attachable step form', attribute_name: :grounds_for_appeal
  end
end
