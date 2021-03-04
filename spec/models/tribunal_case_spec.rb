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

  describe '#has_representative?' do
    let(:attributes) { { has_representative: HasRepresentative.new(value) } }

    context 'when value is `no`' do
      let(:value) { :no }
      it { expect(subject.has_representative?).to eq(false) }
    end

    context 'when value is `yes`' do
      let(:value) { :yes }
      it { expect(subject.has_representative?).to eq(true) }
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
    it 'calls `#intent_case_type`' do
      expect(subject).to receive(:intent_case_type)
      subject.blank?
    end

    it 'returns true if no case type is set' do
      expect(subject).to receive(:intent_case_type).and_return(nil)
      expect(subject.blank?).to eq(true)
    end

    it 'returns false if a case type is set' do
      expect(subject).to receive(:intent_case_type).and_return(CaseType::INCOME_TAX)
      expect(subject.blank?).to eq(false)
    end
  end

  describe '#intent_case_type' do
    context 'for an appeal intent' do
      let(:attributes) { { intent: Intent.new(:tax_appeal) } }

      it 'retrieves the `case_type`' do
        expect(subject).to receive(:case_type)
        subject.intent_case_type
      end
    end

    context 'for a closure intent' do
      let(:attributes) { { intent: Intent.new(:close_enquiry) } }

      it 'retrieves the `closure_case_type`' do
        expect(subject).to receive(:closure_case_type)
        subject.intent_case_type
      end
    end
  end

  describe 'send application details attributes' do
    let(:attributes) do
      { send_taxpayer_copy: SendApplicationDetails.new('no'),
        send_representative_copy: SendApplicationDetails.new('yes') }
    end

    it 'has send application details field for taxpayer' do
      expect(subject.send_taxpayer_copy.to_s).to eq('no')
    end

    it 'has send application details field for representative' do
      expect(subject.send_representative_copy.to_s).to eq('yes')
    end
  end

  describe 'language attribute' do
    let(:attributes) do
      { language: Language.new('English') }
    end

    it 'returns selected language' do
      expect(subject.language.to_s).to eq('English')
    end
  end

  describe '#tax_appeal?' do
    context 'for appeal' do
      let(:attributes) { { intent: Intent::TAX_APPEAL } }

      it { expect(subject).to be_tax_appeal }
    end

    context 'for closure' do
      let(:attributes) { { intent: Intent::CLOSE_ENQUIRY } }

      it { expect(subject).not_to be_tax_appeal }
    end
  end
end
