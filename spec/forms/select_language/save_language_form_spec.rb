require 'spec_helper'

RSpec.describe SelectLanguage::SaveLanguageForm do
  describe '.choices' do
    it 'has the values for the Language value object' do
      expect(described_class.choices).to eq(Language.values.map(&:to_s))
    end
  end

  describe 'language validation' do
    before { subject.language = Language.new(language).to_s }

    context 'true for english' do
      let(:language) { :english }
      it { expect(subject).to be_valid }
    end

    context 'true for english_welsh' do
      let(:language) { :english_welsh }
      it { expect(subject).to be_valid }
    end

    context 'false for spanish' do
      let(:language) { :spanish }
      it { expect(subject).not_to be_valid }
    end
  end
end
