require 'spec_helper'

RSpec.describe DisputeType do
  let(:type) { :foo }
  subject    { described_class.new(type) }

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

  describe '#ask_hardship?' do
    it 'returns false by default' do
      expect(subject.ask_hardship?).to be(false)
    end

    context 'when the dispute type is AMOUNT_OF_TAX' do
      let(:type) { :amount_of_tax }

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
