require 'spec_helper'

RSpec.shared_examples 'sanitizing actions' do
  let(:value) { double.as_null_object }

  specify 'have html escaped' do
    expect(CGI).to receive(:escapeHTML).and_return(value)
    subject.save
  end

  specify 'are sanitized' do
    expect(Sanitize).to receive(:fragment).with('some text', anything).and_return(value)
    subject.save
  end

  specify 'scrub *' do
    allow(CGI).to receive(:escapeHTML).and_return(value)
    expect(value).to receive(:gsub).with('*', anything)
    subject.save
  end

  specify 'scrub =' do
    allow(CGI).to receive(:escapeHTML).and_return(value)
    expect(value).to receive(:gsub).with('=', anything)
    subject.save
  end

  specify 'scrub -' do # kills SQL comments
    allow(CGI).to receive(:escapeHTML).and_return(value)
    expect(value).to receive(:gsub).with('-', anything)
    subject.save
  end

  specify 'scrub %' do
    allow(CGI).to receive(:escapeHTML).and_return(value)
    expect(value).to receive(:gsub).with('%', anything)
    subject.save
  end

  specify 'remove `drop table` case-insensitively'do
    allow(CGI).to receive(:escapeHTML).and_return(value)
    expect(value).to receive(:gsub).with(/drop\s+table/i, anything)
    subject.save
  end

  specify 'remove `insert into` case-insensitively'do
    allow(CGI).to receive(:escapeHTML).and_return(value)
    expect(value).to receive(:gsub).with(/insert\s+into/i, anything)
    subject.save
  end
end

RSpec.describe TribunalCase, type: :model do
  subject { described_class.new(attributes) }
  let(:attributes) { {} }

  describe '#save' do
    context 'columns that store strings' do
      let(:attributes) { { outcome: 'some text' } }
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
        subject.save
      end

      specify 'are not sanitized' do
        expect(Sanitize).not_to receive(:fragment)
        subject.save
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
        subject.save
      end

      specify 'are not sanitized' do
        expect(Sanitize).not_to receive(:fragment)
        subject.save
      end
    end
  end

  describe '#mapping_code' do
    let(:mapping_code) { MappingCode.new(:hmrc_stole_my_cookies) }
    let(:determiner) { instance_double(MappingCodeDeterminer, mapping_code: mapping_code) }

    it 'queries MappingCodeDeterminer for the mapping code' do
      expect(MappingCodeDeterminer).to receive(:new).with(subject).and_return(determiner)
      expect(subject.mapping_code).to eq(mapping_code)
    end
  end

  describe '#documents' do
    let(:collection_ref) { SecureRandom.uuid }
    let(:attributes) { { files_collection_ref: collection_ref } }

    it 'delegates to Document' do
      expect(Document).to receive(:for_collection).with(collection_ref, document_key: :foo)
      subject.documents(:foo)
    end

    it 'memoizes for a given key' do
      expect(Document).to receive(:for_collection).with(collection_ref, document_key: :bar).once.and_return([])

      subject.documents(:bar)
      subject.documents(:bar)
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
    context 'when the intent is CLOSE_ENQUIRY' do
      let(:case_type)  { CaseType.new(:random, appeal_or_application: :whatever) }
      let(:attributes) { { intent: Intent.new(:close_enquiry), case_type: case_type } }

      it 'returns application regardless of case type' do
        expect(subject.appeal_or_application).to eq(:application)
      end
    end

    context 'when the intent is TAX_APPEAL' do
      let(:attributes) { { intent: Intent.new(:tax_appeal), case_type: case_type } }

      context 'when there is no case type' do
        let(:case_type) { nil }

        it 'returns appeal by default' do
          expect(subject.appeal_or_application).to eq(:appeal)
        end
      end

      context 'when there is a case type' do
        let(:case_type)  { CaseType.new(:random, appeal_or_application: :whatever) }

        it 'delegates to the case type' do
          expect(subject.appeal_or_application).to eq(:whatever)
        end
      end
    end
  end
end

