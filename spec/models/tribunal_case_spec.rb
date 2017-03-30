require 'spec_helper'

RSpec.shared_examples 'sanitizing actions' do
  let(:value) { double.as_null_object }

  specify 'have html escaped' do
    expect(CGI).to receive(:escapeHTML).and_return(value)
    subject.send(:sanitize)
  end

  specify 'are sanitized' do
    expect(Sanitize).to receive(:fragment).with('some text', anything).and_return(value)
    subject.send(:sanitize)
  end

  specify 'scrub *' do
    allow(CGI).to receive(:escapeHTML).and_return(value)
    expect(value).to receive(:gsub).with('*', anything)
    subject.send(:sanitize)
  end

  specify 'scrub =' do
    allow(CGI).to receive(:escapeHTML).and_return(value)
    expect(value).to receive(:gsub).with('=', anything)
    subject.send(:sanitize)
  end

  specify 'scrub -' do # kills SQL comments
    allow(CGI).to receive(:escapeHTML).and_return(value)
    expect(value).to receive(:gsub).with('-', anything)
    subject.send(:sanitize)
  end

  specify 'scrub %' do
    allow(CGI).to receive(:escapeHTML).and_return(value)
    expect(value).to receive(:gsub).with('%', anything)
    subject.send(:sanitize)
  end

  specify 'remove `drop table` case-insensitively'do
    allow(CGI).to receive(:escapeHTML).and_return(value)
    expect(value).to receive(:gsub).with(/drop\s+table/i, anything)
    subject.send(:sanitize)
  end

  specify 'remove `insert into` case-insensitively'do
    allow(CGI).to receive(:escapeHTML).and_return(value)
    expect(value).to receive(:gsub).with(/insert\s+into/i, anything)
    subject.send(:sanitize)
  end
end

RSpec.describe TribunalCase, type: :model do
  subject { described_class.new(attributes) }
  let(:attributes) { {} }

  describe '#save' do
    context 'columns that store strings' do
      let(:attributes) { { taxpayer_contact_postcode: 'some text' } }
      include_examples 'sanitizing actions'
    end

    context 'columns that store text' do
      let(:attributes) { { grounds_for_appeal: 'some text' } }
      include_examples 'sanitizing actions'
    end

    context 'columns that store value objects' do
      # Didn't use a double here as it kept getting seralized into a string.
      let(:attributes) { { in_time: InTime::YES } }

      specify 'do not have html escaped' do
        expect(CGI).not_to receive(:escapeHTML)
        subject.send(:sanitize)
      end

      specify 'are not sanitized' do
        expect(Sanitize).not_to receive(:fragment)
        subject.send(:sanitize)
      end
    end

    context 'columns that do not store text or strings' do
      # Didn't use a double here as it kept getting seralized into a string.
      let(:attributes) { { outcome: 'otherwise sanitized' } }
      before do
        allow_any_instance_of(ActiveRecord::ConnectionAdapters::PostgreSQLColumn).to receive(:type).and_return(double)
      end

      specify 'do not have html escaped' do
        expect(CGI).not_to receive(:escapeHTML)
        subject.send(:sanitize)
      end

      specify 'are not sanitized' do
        expect(Sanitize).not_to receive(:fragment)
        subject.send(:sanitize)
      end
    end
  end

  describe '#mapping_code' do
    let(:mapping_code_determiner) { instance_double(MappingCodeDeterminer) }

    it 'queries MappingCodeDeterminer for the mapping code' do
      expect(MappingCodeDeterminer).to receive(:new).and_return(mapping_code_determiner)
      expect(mapping_code_determiner).to receive(:tribunal_case=).with(subject)
      expect(mapping_code_determiner).to receive(:mapping_code)
      subject.mapping_code
    end
  end

  describe '#documents' do
    let(:collection_ref) { SecureRandom.uuid }
    let(:attributes) { { files_collection_ref: collection_ref } }
    let(:documents) { double('Documents') }

    it 'delegates to Document' do
      expect(Document).to receive(:all_for_collection).with(collection_ref).and_return({foo: documents})
      expect(subject.documents(:foo)).to eq(documents)
    end

    it 'returns empty array if no documents found' do
      expect(Document).to receive(:all_for_collection).with(collection_ref).and_return({foo: documents})
      expect(subject.documents(:bar)).to eq([])
    end

    it 'memoizes' do
      expect(Document).to receive(:all_for_collection).with(collection_ref).once.and_return({bar: documents})

      subject.documents(:bar)
      subject.documents(:bar)
    end

    context 'when having_problems_uploading is given' do
      let(:attributes) { super().merge(having_problems_uploading: 'Oh noes') }

      it 'does not return any documents' do
        expect(Document).to_not receive(:all_for_collection)
        expect(subject.documents(:foo)).to be_empty
      end
    end
  end

  describe '#documents_url' do
    let(:collection_ref) { SecureRandom.uuid }
    let(:attributes) { { files_collection_ref: collection_ref } }

    it 'should retrieve the base url from the ENV and append the files collection ref' do
      expect(ENV).to receive(:fetch).with('TAX_TRIBUNALS_DOWNLOADER_URL').and_return('http://downloader.com')
      expect(subject.documents_url).to eq("http://downloader.com/#{collection_ref}")
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

  context 'when the user is the taxpayer' do
    let(:attributes) { { user_type: UserType.new(:taxpayer) } }
    describe '#started_by_taxpayer?' do
      specify { expect(subject.started_by_taxpayer?).to be(true) }
    end

    describe '#started_by_representative?' do
      specify { expect(subject.started_by_representative?).to be(false) }
    end
  end

  context 'when the user is a representative' do
    let(:attributes) { { user_type: UserType.new(:representative)} }
    describe '#started_by_taxpayer?' do
      specify { expect(subject.started_by_taxpayer?).to be(false) }
    end

    describe '#started_by_representative?' do
      specify { expect(subject.started_by_representative?).to be(true) }
    end
  end

  describe '#appeal_or_application' do
    let(:case_type) { instance_double(CaseType).as_null_object }
    let(:intent) { instance_double(Intent).as_null_object }
    let(:attributes) { { intent: intent, case_type: case_type } }

    before do
      allow(subject).to receive(:case_type).and_return(case_type)
      allow(subject).to receive(:intent).and_return(intent)
      allow(intent).to receive(:eql?).with(Intent::CLOSE_ENQUIRY).and_return(false)
    end

    specify 'return :application if intent is to CLOSE_ENQUIRY' do
      expect(intent).to receive(:eql?).with(Intent::CLOSE_ENQUIRY).and_return(true)
      expect(subject.appeal_or_application).to eq(:application)
    end

    specify 'return :appeal if case_type is not set' do
      allow(subject).to receive(:case_type).and_return(nil)
      expect(subject.appeal_or_application).to eq(:appeal)
    end

    it 'delegates :appeal_or_application to case_type by default' do
      expect(case_type).to receive(:appeal_or_application)
      subject.appeal_or_application
    end
  end
end

