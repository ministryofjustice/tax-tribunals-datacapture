require 'spec_helper'

RSpec.describe DisputeType do
  let(:type) { :foo }
  subject    { described_class.new(type) }

  describe '.values' do
    it 'returns all dispute types' do
      expect(described_class.values.map(&:to_s)).to eq(%w(
        penalty
        amount_of_tax_owed_by_hmrc
        amount_of_tax_owed_by_taxpayer
        amount_and_penalty
        paye_coding_notice
        information_notice other
      ))
    end
  end

  describe '#ask_penalty?' do
    it 'returns false by default' do
      expect(subject.ask_penalty?).to be(false)
    end

    context 'when the dispute type is PENALTY' do
      let(:type) { :penalty }

      it 'returns true' do
        expect(subject.ask_penalty?).to be(true)
      end
    end
  end

  describe '#ask_tax?' do
    it 'returns false by default' do
      expect(subject.ask_tax?).to be(false)
    end

    context 'when the dispute type is AMOUNT_OF_TAX_OWED_BY_HMRC' do
      let(:type) { :amount_of_tax_owed_by_hmrc }

      it 'returns true' do
        expect(subject.ask_tax?).to be(true)
      end
    end

    context 'when the dispute type is AMOUNT_OF_TAX_OWED_BY_TAXPAYER' do
      let(:type) { :amount_of_tax_owed_by_taxpayer }

      it 'returns true' do
        expect(subject.ask_tax?).to be(true)
      end
    end
  end

  describe '#ask_penalty_and_tax?' do
    it 'returns false by default' do
      expect(subject.ask_penalty_and_tax?).to be(false)
    end

    context 'when the dispute type is AMOUNT_AND_PENALTY' do
      let(:type) { :amount_and_penalty }

      it 'returns true' do
        expect(subject.ask_penalty_and_tax?).to be(true)
      end
    end
  end

  describe '#ask_hardship?' do
    it 'returns false by default' do
      expect(subject.ask_hardship?).to be(false)
    end

    context 'when the dispute type is AMOUNT_OF_TAX_OWED_BY_HMRC' do
      let(:type) { :amount_of_tax_owed_by_hmrc }

      it 'returns true' do
        expect(subject.ask_hardship?).to be(true)
      end
    end

    context 'when the dispute type is AMOUNT_OF_TAX_OWED_BY_TAXPAYER' do
      let(:type) { :amount_of_tax_owed_by_taxpayer }

      it 'returns true' do
        expect(subject.ask_hardship?).to be(true)
      end
    end

    context 'when the dispute type is AMOUNT_AND_PENALTY' do
      let(:type) { :amount_and_penalty }

      it 'returns true' do
        expect(subject.ask_hardship?).to be(true)
      end
    end
  end
end
