require 'spec_helper'
require_relative 'sanitizer_shared_examples'

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

      specify 'are not sanitized' do
        expect(Sanitize).not_to receive(:fragment)
        subject.send(:sanitize)
      end
    end
  end

  describe '#mapping_code' do
    specify do
      expect(subject).to respond_to(:mapping_code)
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
    context 'Intent::CLOSE_ENQUIRY' do
      let(:intent) { Intent.new(:close_enquiry) }
      let(:attributes) { { intent: intent } }

      specify 'returns :application' do
        expect(subject.appeal_or_application).to eq(:application)
      end
    end

    context 'Intent::TAX_APPEAL and no case type' do
      let(:intent) { Intent.new(:tax_appeal) }
      let(:attributes) { { intent: intent } }

      specify do
        expect(subject.appeal_or_application).to eq(:appeal)
      end
    end

    context 'no intent no case type' do
      let(:attributes) { { } }

      specify do
        expect(subject.appeal_or_application).to eq(:appeal)
      end
    end

    context 'delegates to CaseType' do
      let(:case_type) { CaseType.new(:foo, appeal_or_application: :bar) }
      let(:attributes) { { case_type: case_type } }

      specify do
        expect(subject.appeal_or_application).to eq(:bar)
      end
    end
  end

  describe '#blank?' do
    let(:attributes) { { case_type: case_type, closure_case_type: closure_case_type } }
    let(:case_type) { nil }
    let(:closure_case_type) { nil}

    context 'both `case_type` and `closure_case_type` are not set' do
      it { expect(subject.blank?).to eq(true) }
    end

    context '`case_type` is set' do
      let(:case_type) { CaseType.new(:anything) }
      it { expect(subject.blank?).to eq(false) }
    end

    context '`closure_case_type` is set' do
      let(:closure_case_type) { ClosureCaseType.new(:anything) }
      it { expect(subject.blank?).to eq(false) }
    end
  end
end
