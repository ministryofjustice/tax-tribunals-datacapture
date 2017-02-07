require 'spec_helper'

RSpec.describe TribunalCase, type: :model do
  subject { described_class.new(attributes) }
  let(:attributes) { {} }

  describe '#mapping_code' do
    let(:mapping_code) { MappingCode.new(:hmrc_stole_my_cookies) }
    let(:determiner) { instance_double(MappingCodeDeterminer, mapping_code: mapping_code) }

    it 'queries MappingCodeDeterminer for the mapping code' do
      expect(MappingCodeDeterminer).to receive(:new).with(subject).and_return(determiner)
      expect(subject.mapping_code).to eq(mapping_code)
    end
  end

  describe '#default_documents_filter' do
    let(:attributes) { {grounds_for_appeal_file_name: 'test.doc'} }

    it 'defaults to grounds_for_appeal_file_name' do
      expect(subject.default_documents_filter).to eq(['test.doc'])
    end
  end

  describe '#documents' do
    let(:collection_ref) { SecureRandom.uuid }
    let(:attributes) { {files_collection_ref: collection_ref, grounds_for_appeal_file_name: 'test.doc'} }

    context 'with default filtering' do
      it 'should return the uploaded documents for this tribunal case' do
        expect(Document).to receive(:for_collection).with(collection_ref, filter: ['test.doc'])
        subject.documents
      end
    end
  end

  describe '#taxpayer_is_organisation?' do
    let(:taxpayer_type) { OpenStruct.new(organisation?: true, value: :anything) }
    let(:attributes) { { taxpayer_type: taxpayer_type } }

    it 'queries the taxpayer_type' do
      expect(subject.taxpayer_is_organisation?).to eq(true)
    end
  end

  describe '#representative_is_organisation?' do
    let(:representative_type) { OpenStruct.new(organisation?: true, value: :anything) }
    let(:attributes) { { representative_type: representative_type } }

    it 'queries the representative_type' do
      expect(subject.representative_is_organisation?).to eq(true)
    end
  end
end
