require 'rails_helper'

RSpec.describe Fee do
  let(:level)  { :fee_level_999 }
  subject      { described_class.new(level) }

  it 'is immutable' do
    expect(subject).to be_frozen
  end

  it 'does not accept values that are not implicitly convertible to symbols' do
    expect { described_class.new(12345) }.to raise_error(ArgumentError)
  end

  describe '#value' do
    it 'returns the stored value' do
      expect(subject.value).to eq(:fee_level_999)
    end
  end

  describe '#to_s' do
    it 'returns a string representation of the fee' do
      expect(subject.to_s).to eq('fee_level_999')
    end
  end

  describe '#to_gbp' do
    it 'returns a float representation of the fee from GLiMR in GBP' do
      expect(GlimrFees).to receive(:fee_amount).with(subject).and_return(123_45)
      expect(subject.to_gbp).to eq(123.45)
    end
  end

  describe '#==' do
    context 'when comparing to an equal Fee' do
      let(:other) { described_class.new(level) }

      it 'returns true' do
        expect(subject).to eq(other)
      end
    end

    context 'when comparing to a different fee' do
      let(:other) { described_class.new(:fee_level_111) }

      it 'returns false' do
        expect(subject).to_not eq(other)
      end
    end

    context 'when comparing to a different class' do
      let(:other) { :fee_level_999 }

      it 'returns false' do
        expect(subject).to_not eq(other)
      end
    end
  end
end
